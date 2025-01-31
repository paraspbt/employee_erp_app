import 'package:emperp_app/core/GlobalBloc/global_bloc.dart';
import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget>? actions; // Add a nullable actions parameter
  
  const MyAppBar({super.key, this.actions});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}

class _MyAppBarState extends State<MyAppBar> {
  late final String title;
  late final String currDate;

  @override
  void initState() {
    AppInState appInState = context.read<GlobalBloc>().state as AppInState;
    title = appInState.userModel.name;
    currDate = appInState.currDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            color: AppPallete.darkGreen,
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 4,
      shadowColor: AppPallete.onSurfaceColor,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size(0, 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Text(
            currDate,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppPallete.darkGreen),
          ),
        ),
      ),
      actions: widget.actions ?? [], // Use actions if provided or default to an empty list
    );
  }
}
