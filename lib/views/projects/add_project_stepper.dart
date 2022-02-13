import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:z_collector_app/models/project.dart';
import 'package:z_collector_app/views/projects/add_field.dart';
import 'package:z_collector_app/views/widgets/fields/record_field.dart';

class AddProjectStepper extends StatefulWidget {
  const AddProjectStepper({Key? key}) : super(key: key);

  @override
  State<AddProjectStepper> createState() => _AddProjectStepperState();
}

class _AddProjectStepperState extends State<AddProjectStepper> {
  int _currentStep = 0;
  final _formKeyOne = GlobalKey<FormBuilderState>();
  final List<ProjectField> fields = [];
  final _formKeyThree = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      type: StepperType.horizontal,
      onStepContinue: _onContinue,
      onStepCancel: _onCancel,
      controlsBuilder: _buidControls,
      steps: [
        Step(
          title: const Text('Project Details'),
          content: _StepOne(formKey: _formKeyOne),
          isActive: _currentStep >= 0,
        ),
        Step(
          title: const Text('Form'),
          content: _StepTwo(fields: fields),
          isActive: _currentStep >= 1,
        ),
        Step(
          title: const Text('Publish'),
          content: _StepThree(formKey: _formKeyThree),
          isActive: _currentStep >= 2,
        ),
      ],
    );
  }

  void _onSubmit(bool isDraft) async {
    if (_formKeyThree.currentState?.saveAndValidate() ?? false) {
      final formOneState = _formKeyOne.currentState!;
      final formThreeState = _formKeyThree.currentState!;

      final user = FirebaseAuth.instance.currentUser;
      final project = Project(
        name: formOneState.value['name'],
        description: formOneState.value['description'],
        owner: FirebaseFirestore.instance.collection('users').doc(user?.uid),
        imageUrl: formOneState.value['image'],
        isPrivate: formThreeState.value['isPrivate'] ?? false,
        isPublished: !isDraft,
        entryCode: formThreeState.value['entryCode'],
        allowedUsers: [],
        blacklistedUsers: [],
        fields: fields,
      );

      final data = project.toJson();
      await FirebaseFirestore.instance.collection('projects').add(data);

      Beamer.of(context).beamToNamed("/home");
    }
  }

  _onContinue() {
    if (_currentStep == 0) {
      if (_formKeyOne.currentState?.validate() ?? false) {
        _formKeyOne.currentState?.save();
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    }
  }

  _onCancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget _buidControls(_, controls) => Column(
        children: [
          (controls.currentStep == 2)
              ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _onSubmit(true),
                            child: const Text('Save as Draft'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _onSubmit(false),
                            child: const Text('Publish'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: controls.onStepCancel,
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ],
      );
}

class _StepOne extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const _StepOne({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              label: Text('Project Name'),
              border: OutlineInputBorder(),
            ),
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)],
            ),
          ),
          const SizedBox(height: 8),
          FormBuilderTextField(
            name: 'description',
            decoration: const InputDecoration(
              label: Text('Project Description'),
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required(context)],
            ),
          ),
          const SizedBox(height: 8),
          FormBuilderImagePicker(
            name: "image",
            decoration: const InputDecoration(
              label: Text('Project Image'),
              border: OutlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }
}

class _StepTwo extends StatefulWidget {
  final List<ProjectField> fields;
  const _StepTwo({Key? key, required this.fields}) : super(key: key);

  @override
  State<_StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<_StepTwo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._buildFields(),
        ElevatedButton(
          onPressed: _showAddFieldForm,
          child: const Text("Add Field"),
        ),
      ],
    );
  }

  Future<void> _showAddFieldForm() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddField(onSubmit: _addToFields);
      },
    );
  }

  void _addToFields(ProjectField field) {
    setState(() {
      widget.fields.add(field);
    });
  }

  List<Widget> _buildFields() {
    List<Widget> items = [];
    for (var i = 0; i < widget.fields.length; i++) {
      items.add(Row(
        children: [
          Expanded(
              child: RecordFieldWidget(
            index: i,
            field: widget.fields[i],
          )),
          IconButton(
              onPressed: () {
                setState(() => widget.fields.removeAt(i));
              },
              icon: const Icon(Icons.remove_circle)),
        ],
      ));
    }
    return items;
  }
}

class _StepThree extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  const _StepThree({Key? key, required this.formKey}) : super(key: key);

  @override
  State<_StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends State<_StepThree> {
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    final _formKey = widget.formKey;

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderSwitch(
            name: 'isPrivate',
            title: const Text('Make Private'),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => {
              setState(() => {_isPrivate = val == true})
            },
          ),
          const SizedBox(height: 8),
          _isPrivate
              ? Column(children: [
                  FormBuilderTextField(
                    name: 'entryCode',
                    decoration: const InputDecoration(
                      label: Text('Entry COde'),
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)],
                    ),
                  ),
                  const SizedBox(height: 8)
                ])
              : const SizedBox(),
        ],
      ),
    );
  }
}
