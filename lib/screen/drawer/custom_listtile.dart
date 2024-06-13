import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomListTile extends StatelessWidget {
  final bool isCollapsed;
  final IconData? icon; // Updated type to make it optional
  final String title;
  final IconData? doHaveMoreOptions;
  final int infoCount;
  final Widget? route; // Updated type


  const CustomListTile({
    Key? key,
    required this.isCollapsed,
    this.icon, // Updated type to make it optional
    required this.title,
    this.doHaveMoreOptions,
    required this.infoCount,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route != null) {
          Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute( builder: (BuildContext context) { return route!; }, ));
          Scaffold.of(context).closeDrawer();
        } else {
          print('no route');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isCollapsed ? 300 : 80,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (icon != null) // Check if icon is not null before adding it
                      Icon(
                        icon,
                        color: Colors.white,
                      ),
                    if (infoCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isCollapsed) const SizedBox(width: 10),
            if (isCollapsed)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        title,
                        style: GoogleFonts.notoSerifKhmer(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    if (infoCount > 0)
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              infoCount.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            if (isCollapsed) const Spacer(),
            if (isCollapsed)
              Expanded(
                flex: 1,
                child: doHaveMoreOptions != null
                    ? IconButton(
                  icon: Icon(
                    doHaveMoreOptions,
                    color: Colors.white,
                    size: 12,
                  ),
                  onPressed: () {},
                )
                    : const Center(),
              ),
          ],
        ),
      ),
    );
  }
}
