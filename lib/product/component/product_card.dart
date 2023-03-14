import 'package:acutal/common/const/colors.dart';
import 'package:acutal/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  }) : super(key: key);

  factory ProductCard.fromModel({required RestaurantProductModel model}) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  // Image.asset(
  // 'asset/img/food/ddeok_bok_gi.jpg',
  // width: 110,
  // height: 110,
  // fit: BoxFit.cover,
  // ),

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // 최대 크기로 확장 시키기 위해 사용,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: TextStyle(fontSize: 18)),
                Text(detail,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, color: BODY_TEXT_COLOR, fontWeight: FontWeight.w500)),
                Text(
                  '￦$price',
                  style: TextStyle(color: PRIMARY_COLOR, fontSize: 12.0, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
