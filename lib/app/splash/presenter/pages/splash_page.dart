import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tree_view_app/app/splash/presenter/cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    redirect();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linearToEaseOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> redirect() async {
    await BlocProvider.of<SplashCubit>(context).firstCharge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Theme.of(context).colorScheme.primary,
        ),
        Center(
          child: SlideTransition(
            position: _positionAnimation,
            child: Image.asset(
              "assets/images/logo.png",
              height: 200,
              width: 200,
            ),
          ),
        ),
      ],
    ));
  }
}
