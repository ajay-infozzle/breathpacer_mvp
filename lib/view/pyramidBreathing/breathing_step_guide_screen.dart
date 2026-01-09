import 'package:breathpacer_mvp/bloc/content/content_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/widget/step_guide_container_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BreathingStepGuideScreen extends StatelessWidget {
  const BreathingStepGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width ;
    final contentCubit = context.read<ContentCubit>() ;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.colors.linearGradient
        ),
        child: Column(
          children: [
            AppBar(
              scrolledUnderElevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(Icons.arrow_back_ios),
              ),
              title: const Text(
                "Pyramid Breathing",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              width: size,
              child: CircleAvatar(
                radius: size*0.075,
                // child: Image.asset(contentCubit.imagePath+contentCubit.images.pyramidIcon!),
                child: CachedNetworkImage(imageUrl: contentCubit.imagePath+contentCubit.images.pyramidIcon!, cacheKey: contentCubit.imagePath+contentCubit.images.pyramidIcon!,),
              ),
            ),
            
            SizedBox(height: size*0.04,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size*0.05),
              color: Colors.white.withOpacity(.3),
              height: 1,
            ),

            //~
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: size*0.05, left: size*0.05),
                child: ListView.builder(
                  padding: const EdgeInsetsDirectional.all(0),
                  itemCount: contentCubit.breathingStepGuide.length+1,
                  itemBuilder: (context, index) {
                    if(index == contentCubit.breathingStepGuide.length){
                      return SizedBox(height: size*0.06,);
                    }
                    return StepGuideContainerWidget(
                      title: contentCubit.breathingStepGuide[index].title!, 
                      description: contentCubit.breathingStepGuide[index].description!,
                      onTap: (){
                        if(index == 0){
                          context.pushReplacementNamed(
                            RoutesName.pyramidSettingScreen,
                            extra:{
                              "step" : "4"
                            }
                          );
                        }
                        if(index == 1){
                          context.pushReplacementNamed(
                            RoutesName.pyramidSettingScreen,
                            extra:{
                              "step" : "2"
                            }
                          );
                        }
                      }, 
                    );
                  },
                ),
              ), 
            ),
          ],
        ),
      ),
    );
  }
}