import 'package:flutter/material.dart';
import 'general_button.dart';
import 'hamburger_menu.dart';

class PrimaryAppBar extends StatefulWidget {
  String page;
  PrimaryAppBar({super.key, required this.page});

  @override
  State<PrimaryAppBar> createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  String userDP =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png';

  @override
  Widget build(BuildContext context) {
    fillAccountList(context);
    GeneralButton dropdownValue = accountDropdown[0];
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text('Fimbria',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Inria',
            fontWeight: FontWeight.w400,
            color: Colors.black,
          )),
      leading: Container(
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/logo.png'),
              fit: BoxFit.contain,
              alignment: Alignment.center),
        ),
      ),
      actions: [
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            child: PopupMenuButton<GeneralButton>(
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(userDP),
                radius: 30,
              ),
              onSelected: (GeneralButton? value) {
                setState(() {
                  dropdownValue = value!;
                });
                // getAPI();
              },
              itemBuilder: (BuildContext context) => accountDropdown
                  .map<PopupMenuItem<GeneralButton>>((GeneralButton value) {
                return PopupMenuItem<GeneralButton>(
                  value: value,
                  child: value,
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 15),
      ],
      // bottom: PreferredSize(
      //   child: SecondaryAppbar(
      //     page: widget.page,
      //   ),
      //   preferredSize: const Size.fromHeight(48.0),
      // )
    );
  }
}