import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/ui/web/admin/admin_components/user_profile.dart';
import 'package:wokr4ututor/ui/web/admin/admin_models/admin_model.dart';
import 'package:wokr4ututor/ui/web/admin/executive_dashboard.dart';
import 'package:wokr4ututor/ui/web/admin/my_admins/add_admin.dart';

class AdminData {
  final String adminname;
  final String adminaddress;
  final String adminID;
  final String adminEmail;
  final DateTime dateregisterd;
  final DateTime adminposition;
  final String adminpassword;

  const AdminData({
    required this.adminname,
    required this.adminaddress,
    required this.adminID,
    required this.adminEmail,
    required this.dateregisterd,
    required this.adminposition,
    required this.adminpassword,
  });
}

class AdminList extends StatelessWidget {
  AdminList({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    return Obx(() {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: kSpacing / 2,
          mainAxisSpacing: kSpacing, // Horizontal spacing between columns
        ),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.adminsList.value.length,
        itemBuilder: (context, index) {
          dynamic data = controller.adminsList.value[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 50,
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 228, 227, 227), Colors.white],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: _BackgroundDecoration(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildLabel(),
                            const SizedBox(height: 5),
                            _buildJobdesk(),
                          ],
                        ),
                      ),

                      _buildCompanyName(data),
                      // const SizedBox(height: 10),

                      // _buildDate(),
                      const Spacer(flex: 1),
                      _acceptButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildCompanyName(AdminsInformation data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: UserProfile(
            data: UserProfileData(
              image: const AssetImage('assets/images/man.png'),
              name: "${data.firstname} ${data.lastname}",
              jobDesk: data.position,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID number: ${(data.adminID)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kFontColorPallets[1],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Address: ${(data.address)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kFontColorPallets[1],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Contact: ${(data.contactnumber)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kFontColorPallets[1],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Email: ${(data.email)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kFontColorPallets[1],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel() {
    return const Text(
      "WORK4UTUTOR",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: Colors.black,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildJobdesk() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: const Text(
        "Work4ututor Philippines",
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
          letterSpacing: 1,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDate(DateTime data) {
    return _IconLabel(
      color: Colors.black,
      iconData: EvaIcons.calendarOutline,
      label: "${(data)}",
    );
  }

  Widget _buildHours() {
    return const _IconLabel(
      color: Colors.black,
      iconData: EvaIcons.clockOutline,
      label: "data.dateAccepted.dueDate()",
    );
  }

  Widget _acceptButton() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
          ),
          icon: const Center(child: Icon(EvaIcons.closeCircleOutline)),
          label: const Text("Block"),
        ),
      ],
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(.5),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 130,
              backgroundColor: Colors.white.withOpacity(.5),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
