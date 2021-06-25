
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contact.dart';
import 'package:wakaman_app/util/contact_service.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:country_code_picker/country_code_picker.dart';


class SubmitRequest extends StatefulWidget {
  SubmitRequest({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SubmitRequestState createState() => new _SubmitRequestState();
}

class _SubmitRequestState extends State<SubmitRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';
  Contact newContact = new Contact();
  final TextEditingController _controller = new TextEditingController();

  final countryControler = TextEditingController();
  final phoneController = TextEditingController();
  final despController = TextEditingController();

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Name: ${newContact.name}');
      print('Dob: ${newContact.dob}');
      print('Phone: ${newContact.phone}');
      print('Email: ${newContact.email}');
      print('Favorite Color: ${newContact.favoriteColor}');
      print('========================================');
      print('Submitting to back end...');
      var contactService = new ContactService();
      contactService.createContact(newContact).then((value) =>
          showMessage('New contact created for ${value.name}!', Colors.blue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Waka-Man",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: <Widget>[

          Container(
            margin: EdgeInsets.only(left: 16, top: 8,),
            width: 60,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),


        ],
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) => newContact.name = val,
                  ),
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            hintText: 'Enter your date of birth',
                            labelText: 'Dob',
                          ),
                          controller: _controller,
                          keyboardType: TextInputType.datetime,
                          validator: (val) =>
                          isValidDob(val) ? null : 'Not a valid date',
                          onSaved: (val) => newContact.dob = convertToDate(val),
                        )),
                    new IconButton(
                      icon: new Icon(Icons.more_horiz),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, _controller.text);
                      }),
                    )
                  ]),

                  new SizedBox(
                    height: 10.0,
                  ),
                  /*
                  new TextFormField(
                    onSaved: (val) => newContact.phone = val,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      contentPadding: EdgeInsets.fromLTRB(
                          20.0, 4.0, 20.0, 4.0),
                      prefix: new CountryCodePicker(
                        onChanged: print,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'CM',
                        favorite: ['+237', 'CM'],
                        textStyle:
                        TextStyle(color: Colors.grey),
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        //  showOnlyCountryCodeWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                      filled: true,
                      fillColor: CupertinoColors.white,
                      border: const OutlineInputBorder(),
                      suffixText: '',
                      suffixStyle: const TextStyle(
                          color: Colors.green),
                    ),
                  ),
                  */
                  new TextFormField(
                    decoration:  InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                      prefix: new CountryCodePicker(
                        onChanged: print,
                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'CM',
                        favorite: ['+237', 'CM'],
                        textStyle:
                        TextStyle(color: Colors.grey),
                        // optional. Shows only country name and flag
                        showCountryOnly: false,
                        // optional. Shows only country name and flag when popup is closed.
                        //  showOnlyCountryCodeWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9),
                    ],
                    validator: (value) => isValidPhoneNumber(value)
                        ? null
                        : 'Phone number must be entered as (###)###-####',
                    onSaved: (val) => newContact.phone = val,
                  ),

                  /*
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      new WhitelistingTextInputFormatter(
                          new RegExp(r'^[()\d -]{1,15}$')),
                    ],
                    validator: (value) => isValidPhoneNumber(value)
                        ? null
                        : 'Phone number must be entered as (###)###-####',
                    onSaved: (val) => newContact.phone = val,
                  ),
                  */
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                    onSaved: (val) => newContact.email = val,
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                  new MultiSelect(
                    autovalidate: true,
                    initialValue: ['CA', 'US'],
                    titleText: 'Country Choice',
                    maxLength: 5, // optional
                    validator: (dynamic value) {
                      if (value == null) {
                        return 'Please select one or more option(s)';
                      }
                      return null;
                    },
                    errorText: 'Please select one or more option(s)',
                    dataSource: [
                      {"name": "Afghanistan", "code": "AF"},
                      {"name": "Åland Islands", "code": "AX"},
                      {"name": "Albania", "code": "AL"},
                      {"name": "Algeria", "code": "DZ"},
                      {"name": "American Samoa", "code": "AS"},
                      {"name": "AndorrA", "code": "AD"},
                      {"name": "Angola", "code": "AO"},
                      {"name": "Anguilla", "code": "AI"},
                      {"name": "Antarctica", "code": "AQ"},
                      {"name": "Antigua and Barbuda", "code": "AG"},
                      {"name": "Argentina", "code": "AR"},
                      {"name": "Armenia", "code": "AM"},
                      {"name": "Aruba", "code": "AW"},
                      {"name": "Australia", "code": "AU"},
                      {"name": "Austria", "code": "AT"},
                      {"name": "Azerbaijan", "code": "AZ"},
                      {"name": "Bahamas", "code": "BS"},
                      {"name": "Bahrain", "code": "BH"},
                      {"name": "Bangladesh", "code": "BD"},
                      {"name": "Barbados", "code": "BB"},
                      {"name": "Belarus", "code": "BY"},
                      {"name": "Belgium", "code": "BE"},
                      {"name": "Belize", "code": "BZ"},
                      {"name": "Benin", "code": "BJ"},
                      {"name": "Bermuda", "code": "BM"},
                      {"name": "Bhutan", "code": "BT"},
                      {"name": "Bolivia", "code": "BO"},
                      {"name": "Bosnia and Herzegovina", "code": "BA"},
                      {"name": "Botswana", "code": "BW"},
                      {"name": "Bouvet Island", "code": "BV"},
                      {"name": "Brazil", "code": "BR"},
                      {"name": "British Indian Ocean Territory", "code": "IO"},
                      {"name": "Brunei Darussalam", "code": "BN"},
                      {"name": "Bulgaria", "code": "BG"},
                      {"name": "Burkina Faso", "code": "BF"},
                      {"name": "Burundi", "code": "BI"},
                      {"name": "Cambodia", "code": "KH"},
                      {"name": "Cameroon", "code": "CM"},
                      {"name": "Canada", "code": "CA"},
                      {"name": "Cape Verde", "code": "CV"},
                      {"name": "Cayman Islands", "code": "KY"},
                      {"name": "Central African Republic", "code": "CF"},
                      {"name": "Chad", "code": "TD"},
                      {"name": "Chile", "code": "CL"},
                      {"name": "China", "code": "CN"},
                      {"name": "Christmas Island", "code": "CX"},
                      {"name": "Cocos (Keeling) Islands", "code": "CC"},
                      {"name": "Colombia", "code": "CO"},
                      {"name": "Comoros", "code": "KM"},
                      {"name": "Congo", "code": "CG"},
                      {"name": "Congo, The Democratic Republic of the", "code": "CD"},
                      {"name": "Cook Islands", "code": "CK"},
                      {"name": "Costa Rica", "code": "CR"},
                      {"name": "Cote D\'Ivoire", "code": "CI"},
                      {"name": "Croatia", "code": "HR"},
                      {"name": "Cuba", "code": "CU"},
                      {"name": "Cyprus", "code": "CY"},
                      {"name": "Czech Republic", "code": "CZ"},
                      {"name": "Denmark", "code": "DK"},
                      {"name": "Djibouti", "code": "DJ"},
                      {"name": "Dominica", "code": "DM"},
                      {"name": "Dominican Republic", "code": "DO"},
                      {"name": "Ecuador", "code": "EC"},
                      {"name": "Egypt", "code": "EG"},
                      {"name": "El Salvador", "code": "SV"},
                      {"name": "Equatorial Guinea", "code": "GQ"},
                      {"name": "Eritrea", "code": "ER"},
                      {"name": "Estonia", "code": "EE"},
                      {"name": "Ethiopia", "code": "ET"},
                      {"name": "Falkland Islands (Malvinas)", "code": "FK"},
                      {"name": "Faroe Islands", "code": "FO"},
                      {"name": "Fiji", "code": "FJ"},
                      {"name": "Finland", "code": "FI"},
                      {"name": "France", "code": "FR"},
                      {"name": "French Guiana", "code": "GF"},
                      {"name": "French Polynesia", "code": "PF"},
                      {"name": "French Southern Territories", "code": "TF"},
                      {"name": "Gabon", "code": "GA"},
                      {"name": "Gambia", "code": "GM"},
                      {"name": "Georgia", "code": "GE"},
                      {"name": "Germany", "code": "DE"},
                      {"name": "Ghana", "code": "GH"},
                      {"name": "Gibraltar", "code": "GI"},
                      {"name": "Greece", "code": "GR"},
                      {"name": "Greenland", "code": "GL"},
                      {"name": "Grenada", "code": "GD"},
                      {"name": "Guadeloupe", "code": "GP"},
                      {"name": "Guam", "code": "GU"},
                      {"name": "Guatemala", "code": "GT"},
                      {"name": "Guernsey", "code": "GG"},
                      {"name": "Guinea", "code": "GN"},
                      {"name": "Guinea-Bissau", "code": "GW"},
                      {"name": "Guyana", "code": "GY"},
                      {"name": "Haiti", "code": "HT"},
                      {"name": "Heard Island and Mcdonald Islands", "code": "HM"},
                      {"name": "Holy See (Vatican City State)", "code": "VA"},
                      {"name": "Honduras", "code": "HN"},
                      {"name": "Hong Kong", "code": "HK"},
                      {"name": "Hungary", "code": "HU"},
                      {"name": "Iceland", "code": "IS"},
                      {"name": "India", "code": "IN"},
                      {"name": "Indonesia", "code": "ID"},
                      {"name": "Iran, Islamic Republic Of", "code": "IR"},
                      {"name": "Iraq", "code": "IQ"},
                      {"name": "Ireland", "code": "IE"},
                      {"name": "Isle of Man", "code": "IM"},
                      {"name": "Israel", "code": "IL"},
                      {"name": "Italy", "code": "IT"},
                      {"name": "Jamaica", "code": "JM"},
                      {"name": "Japan", "code": "JP"},
                      {"name": "Jersey", "code": "JE"},
                      {"name": "Jordan", "code": "JO"},
                      {"name": "Kazakhstan", "code": "KZ"},
                      {"name": "Kenya", "code": "KE"},
                      {"name": "Kiribati", "code": "KI"},
                      {"name": "Korea, Democratic People\'s Republic of", "code": "KP"},
                      {"name": "Korea, Republic of", "code": "KR"},
                      {"name": "Kuwait", "code": "KW"},
                      {"name": "Kyrgyzstan", "code": "KG"},
                      {"name": "Lao People\'s Democratic Republic", "code": "LA"},
                      {"name": "Latvia", "code": "LV"},
                      {"name": "Lebanon", "code": "LB"},
                      {"name": "Lesotho", "code": "LS"},
                      {"name": "Liberia", "code": "LR"},
                      {"name": "Libyan Arab Jamahiriya", "code": "LY"},
                      {"name": "Liechtenstein", "code": "LI"},
                      {"name": "Lithuania", "code": "LT"},
                      {"name": "Luxembourg", "code": "LU"},
                      {"name": "Macao", "code": "MO"},
                      {"name": "Macedonia, The Former Yugoslav Republic of", "code": "MK"},
                      {"name": "Madagascar", "code": "MG"},
                      {"name": "Malawi", "code": "MW"},
                      {"name": "Malaysia", "code": "MY"},
                      {"name": "Maldives", "code": "MV"},
                      {"name": "Mali", "code": "ML"},
                      {"name": "Malta", "code": "MT"},
                      {"name": "Marshall Islands", "code": "MH"},
                      {"name": "Martinique", "code": "MQ"},
                      {"name": "Mauritania", "code": "MR"},
                      {"name": "Mauritius", "code": "MU"},
                      {"name": "Mayotte", "code": "YT"},
                      {"name": "Mexico", "code": "MX"},
                      {"name": "Micronesia, Federated States of", "code": "FM"},
                      {"name": "Moldova, Republic of", "code": "MD"},
                      {"name": "Monaco", "code": "MC"},
                      {"name": "Mongolia", "code": "MN"},
                      {"name": "Montserrat", "code": "MS"},
                      {"name": "Morocco", "code": "MA"},
                      {"name": "Mozambique", "code": "MZ"},
                      {"name": "Myanmar", "code": "MM"},
                      {"name": "Namibia", "code": "NA"},
                      {"name": "Nauru", "code": "NR"},
                      {"name": "Nepal", "code": "NP"},
                      {"name": "Netherlands", "code": "NL"},
                      {"name": "Netherlands Antilles", "code": "AN"},
                      {"name": "New Caledonia", "code": "NC"},
                      {"name": "New Zealand", "code": "NZ"},
                      {"name": "Nicaragua", "code": "NI"},
                      {"name": "Niger", "code": "NE"},
                      {"name": "Nigeria", "code": "NG"},
                      {"name": "Niue", "code": "NU"},
                      {"name": "Norfolk Island", "code": "NF"},
                      {"name": "Northern Mariana Islands", "code": "MP"},
                      {"name": "Norway", "code": "NO"},
                      {"name": "Oman", "code": "OM"},
                      {"name": "Pakistan", "code": "PK"},
                      {"name": "Palau", "code": "PW"},
                      {"name": "Palestinian Territory, Occupied", "code": "PS"},
                      {"name": "Panama", "code": "PA"},
                      {"name": "Papua New Guinea", "code": "PG"},
                      {"name": "Paraguay", "code": "PY"},
                      {"name": "Peru", "code": "PE"},
                      {"name": "Philippines", "code": "PH"},
                      {"name": "Pitcairn", "code": "PN"},
                      {"name": "Poland", "code": "PL"},
                      {"name": "Portugal", "code": "PT"},
                      {"name": "Puerto Rico", "code": "PR"},
                      {"name": "Qatar", "code": "QA"},
                      {"name": "Reunion", "code": "RE"},
                      {"name": "Romania", "code": "RO"},
                      {"name": "Russian Federation", "code": "RU"},
                      {"name": "RWANDA", "code": "RW"},
                      {"name": "Saint Helena", "code": "SH"},
                      {"name": "Saint Kitts and Nevis", "code": "KN"},
                      {"name": "Saint Lucia", "code": "LC"},
                      {"name": "Saint Pierre and Miquelon", "code": "PM"},
                      {"name": "Saint Vincent and the Grenadines", "code": "VC"},
                      {"name": "Samoa", "code": "WS"},
                      {"name": "San Marino", "code": "SM"},
                      {"name": "Sao Tome and Principe", "code": "ST"},
                      {"name": "Saudi Arabia", "code": "SA"},
                      {"name": "Senegal", "code": "SN"},
                      {"name": "Serbia and Montenegro", "code": "CS"},
                      {"name": "Seychelles", "code": "SC"},
                      {"name": "Sierra Leone", "code": "SL"},
                      {"name": "Singapore", "code": "SG"},
                      {"name": "Slovakia", "code": "SK"},
                      {"name": "Slovenia", "code": "SI"},
                      {"name": "Solomon Islands", "code": "SB"},
                      {"name": "Somalia", "code": "SO"},
                      {"name": "South Africa", "code": "ZA"},
                      {"name": "South Georgia and the South Sandwich Islands", "code": "GS"},
                      {"name": "Spain", "code": "ES"},
                      {"name": "Sri Lanka", "code": "LK"},
                      {"name": "Sudan", "code": "SD"},
                      {"name": "Suriname", "code": "SR"},
                      {"name": "Svalbard and Jan Mayen", "code": "SJ"},
                      {"name": "Swaziland", "code": "SZ"},
                      {"name": "Sweden", "code": "SE"},
                      {"name": "Switzerland", "code": "CH"},
                      {"name": "Syrian Arab Republic", "code": "SY"},
                      {"name": "Taiwan, Province of China", "code": "TW"},
                      {"name": "Tajikistan", "code": "TJ"},
                      {"name": "Tanzania, United Republic of", "code": "TZ"},
                      {"name": "Thailand", "code": "TH"},
                      {"name": "Timor-Leste", "code": "TL"},
                      {"name": "Togo", "code": "TG"},
                      {"name": "Tokelau", "code": "TK"},
                      {"name": "Tonga", "code": "TO"},
                      {"name": "Trinidad and Tobago", "code": "TT"},
                      {"name": "Tunisia", "code": "TN"},
                      {"name": "Turkey", "code": "TR"},
                      {"name": "Turkmenistan", "code": "TM"},
                      {"name": "Turks and Caicos Islands", "code": "TC"},
                      {"name": "Tuvalu", "code": "TV"},
                      {"name": "Uganda", "code": "UG"},
                      {"name": "Ukraine", "code": "UA"},
                      {"name": "United Arab Emirates", "code": "AE"},
                      {"name": "United Kingdom", "code": "GB"},
                      {"name": "United States", "code": "US"},
                      {"name": "United States Minor Outlying Islands", "code": "UM"},
                      {"name": "Uruguay", "code": "UY"},
                      {"name": "Uzbekistan", "code": "UZ"},
                      {"name": "Vanuatu", "code": "VU"},
                      {"name": "Venezuela", "code": "VE"},
                      {"name": "Viet Nam", "code": "VN"},
                      {"name": "Virgin Islands, British", "code": "VG"},
                      {"name": "Virgin Islands, U.S.", "code": "VI"},
                      {"name": "Wallis and Futuna", "code": "WF"},
                      {"name": "Western Sahara", "code": "EH"},
                      {"name": "Yemen", "code": "YE"},
                      {"name": "Zambia", "code": "ZM"},
                      {"name": "Zimbabwe", "code": "ZW"}
                    ],
                    textField: 'name',
                    valueField: 'code',
                    filterable: true,
                    required: true,
                    onSaved: (value) {
                      print('The value is $value');
                      newContact.country = value;
                    },
                    selectIcon: Icons.arrow_drop_down_circle,
                    saveButtonColor: Theme.of(context).primaryColor,
                    checkBoxColor: Theme.of(context).primaryColorDark,
                    cancelButtonColor: Theme.of(context).primaryColorLight,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: despController,
                    keyboardType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(255),
                    ],
                    decoration:  InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            20.0, 15.0, 20.0, 15.0),
                        filled: true,
                        fillColor: CupertinoColors.white,
                        border: const OutlineInputBorder(),
                        labelText: "Briefly tell us your need",
                        suffixStyle: const TextStyle(
                            color: Colors.grey)),
                    maxLines: 4,
                    onSaved: (val) => newContact.desp = val,
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  /*
                  new FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.color_lens),
                          labelText: 'Color',
                          errorText: state.hasError ? state.errorText : null,
                        ),
                        isEmpty: _color == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            value: _color,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                newContact.favoriteColor = newValue;
                                _color = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _colors.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    validator: (val) {
                      return val != '' ? null : 'Please select a color';
                    },
                  ),

                  */
                  new Container(
                      padding: const EdgeInsets.only( top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: _submitForm,
                      )),
                ],
              ))),
    );
  }
}
