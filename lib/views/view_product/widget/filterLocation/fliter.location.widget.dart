import 'package:flutter/material.dart';

import 'package:products_app/constants/app_color.dart';
import 'package:products_app/constants/app_fontsize.dart';
import 'package:products_app/model/location.model.dart';

class FilterOptionLocation {
  final String title;
  final List<Location> options;

  FilterOptionLocation({
    required this.title,
    required this.options,
  });
}

class FliterButtonLocation extends StatefulWidget {
  final String nameFilter;
  final Map<String, String> selectedOptions;
  final IconData icon;
  final List<FilterOptionLocation> filterOptions;
  final void Function(String, String) onOptionSelected;

  FliterButtonLocation({
    Key? key,
    required this.icon,
    required this.nameFilter,
    required this.selectedOptions,
    required this.filterOptions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  State<FliterButtonLocation> createState() => _FliterButtonLocationState();
}

class _FliterButtonLocationState extends State<FliterButtonLocation> {
  bool isSelected = false;
  List<String> selectedIds = ['79', '01', '48'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Icon(widget.icon),
          SizedBox(width: 5),
          Text(
            widget.nameFilter,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Map<String, String> tempSelectedOptions =
                  Map.from(widget.selectedOptions);

              showModalBottomSheet(
                isScrollControlled:
                    true, // Cho phép toàn bộ màn hình scroll theo nội dung
                isDismissible: true, // Cho phép vuốt xuống để đóng
                enableDrag: true,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.filterOptions.map((filterOption) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        filterOption.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_city),
                                        Text(
                                          '  Tìm kiếm theo khu vực',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Phổ biến: ',
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Khoảng cách nhỏ giữa 'Phổ biến:' và các ChoiceChip
                                        Wrap(
                                          spacing: 5,
                                          runSpacing:
                                              5, // Khoảng cách giữa các dòng khi xuống dòng
                                          children: [
                                            ChoiceChip(
                                              label: Text(
                                                'Toàn quốc',
                                                style: TextStyle(
                                                  color: tempSelectedOptions[
                                                              filterOption
                                                                  .title] ==
                                                          'Toàn quốc'
                                                      ? AppColor
                                                          .extraColor // Màu chữ khi được chọn
                                                      : AppColor
                                                          .darkColor, // Màu chữ khi chưa được chọn
                                                ),
                                              ),
                                              selected: tempSelectedOptions[
                                                      filterOption.title] ==
                                                  'Toàn quốc',
                                              onSelected: (selected) {
                                                setState(() {
                                                  tempSelectedOptions[
                                                          filterOption.title] =
                                                      'Toàn quốc';
                                                  isSelected = true;
                                                });
                                                widget.onOptionSelected(
                                                    filterOption.title,
                                                    'Toàn quốc');
                                                Navigator.pop(context);
                                              },
                                              selectedColor:
                                                  AppColor.primaryColor,
                                              checkmarkColor:
                                                  AppColor.extraColor,
                                            ),
                                            ...filterOption.options
                                                .where((option) => selectedIds
                                                    .contains(option.id))
                                                .map((option) {
                                              return ChoiceChip(
                                                checkmarkColor:
                                                    AppColor.extraColor,
                                                selectedColor:
                                                    AppColor.primaryColor,
                                                label: Text(
                                                  option.name,
                                                  style: TextStyle(
                                                    color: tempSelectedOptions[
                                                                filterOption
                                                                    .title] ==
                                                            option.name
                                                        ? AppColor
                                                            .extraColor // Màu chữ khi được chọn
                                                        : AppColor
                                                            .darkColor, // Màu chữ khi chưa được chọn
                                                  ),
                                                ),
                                                selected: tempSelectedOptions[
                                                        filterOption.title] ==
                                                    option.name,
                                                onSelected: (selected) {
                                                  setState(() {
                                                    tempSelectedOptions[
                                                            filterOption
                                                                .title] =
                                                        option.name;
                                                    isSelected = true;
                                                  });
                                                  widget.onOptionSelected(
                                                      filterOption.title,
                                                      option.name);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }).toList(),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(
                                      height: 5,
                                      thickness: 1,
                                    ),
                                    SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            return FractionallySizedBox(
                                              heightFactor:
                                                  0.8, // Chiều cao của BottomSheet (50% màn hình)
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          "Chọn khu vực",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: filterOption
                                                            .options
                                                            .map((option) {
                                                          return ListTile(
                                                            title: Text(
                                                                option.name),
                                                            trailing: Checkbox(
                                                              checkColor: AppColor
                                                                  .extraColor,
                                                              activeColor: AppColor
                                                                  .primaryColor,
                                                              value: tempSelectedOptions[
                                                                      filterOption
                                                                          .title] ==
                                                                  option.name,
                                                              onChanged: (bool?
                                                                  selected) {
                                                                setState(() {
                                                                  if (selected ==
                                                                      true) {
                                                                    tempSelectedOptions[
                                                                        filterOption
                                                                            .title] = option
                                                                        .name;
                                                                    isSelected =
                                                                        true;
                                                                  } else {
                                                                    tempSelectedOptions
                                                                        .remove(
                                                                            filterOption.title);
                                                                  }
                                                                });
                                                                Navigator.pop(
                                                                    context); // Đóng BottomSheet khi chọn xong
                                                              },
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                tempSelectedOptions[
                                                                    filterOption
                                                                        .title] = option
                                                                    .name;
                                                                isSelected =
                                                                    true;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.extraColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              color: Colors.grey.shade400),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            tempSelectedOptions[
                                                    filterOption.title] ??
                                                'Chọn khu vực',
                                            style: TextStyle(
                                              fontSize: AppFontSize.sizeSmall,
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            '>',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              }).toList(),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    tempSelectedOptions.forEach((key, value) {
                                      widget.onOptionSelected(key, value);
                                    });
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColor.primaryColor, // Màu nền vàng
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Loại bỏ bo góc
                                    ),
                                  ),
                                  child: Text(
                                    'Xác nhận',
                                    style:
                                        TextStyle(color: AppColor.extraColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Row(
              children: [
                Text(
                  _getSelectedOptionsText(), // Hiển thị giá trị đã chọn
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: isSelected ? AppColor.primaryColor : Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color: isSelected ? AppColor.primaryColor : Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedOptionsText() {
    return widget.selectedOptions.entries
        .where((entry) => entry.value != '')
        .map((entry) => entry.value)
        .join(', ');
  }
}
