import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'product_carousel_state.dart';

class ProductCarouselCubit extends Cubit<int> {
  ProductCarouselCubit() : super(0);
 int currentIndex =0;

 changeIndex(index){
   emit(currentIndex = index);
 }

}
