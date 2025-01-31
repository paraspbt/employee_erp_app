import 'package:emperp_app/core/NavBloc/navigation_bloc.dart';
import 'package:emperp_app/core/theme/app_pallete.dart';
import 'package:emperp_app/core/widgets/my_app_bar.dart';
import 'package:emperp_app/features/erp/presentation/pages/dash_board.dart';
import 'package:emperp_app/features/erp/presentation/pages/emp_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static route() => MaterialPageRoute(builder: (context) => const MainScreen());

  final List<Widget> pages = const [
    DashBoard(),
    EmpListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const MyAppBar(),
          body: IndexedStack(
            index: (state as CurrNavState).index,
            children: pages,
          ),
          bottomNavigationBar: Material(
            elevation: 16,
            child: BottomNavigationBar(
              backgroundColor: AppPallete.backgroundColor,
              selectedItemColor: AppPallete.darkGreen,
              unselectedItemColor: AppPallete.dullGreen,
              iconSize: 32,
              currentIndex: state.index,
              onTap: (index) {
                context.read<NavigationBloc>().add(NavChangeEvent(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Employees',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
