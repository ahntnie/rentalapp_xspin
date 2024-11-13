import 'package:flutter/material.dart';
import 'package:products_app/constants/app_color.dart';
import 'package:products_app/model/caterogies_model.dart';

class FilterOption {
  final String title;
  final List<Categories> options;

  FilterOption({
    required this.title,
    required this.options,
  });
}

class FilterButton extends StatefulWidget {
  final String nameFilter;
  final Map<String, String> selectedOptions;
  final IconData icon;
  final List<FilterOption> filterOptions;
  final void Function(String, String) onOptionSelected;

  FilterButton({
    Key? key,
    required this.icon,
    required this.nameFilter,
    required this.selectedOptions,
    required this.filterOptions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị mặc định cho từng `filterOption.title`
    for (var filterOption in widget.filterOptions) {
      widget.selectedOptions.putIfAbsent(filterOption.title, () => "Tất cả");
    }
    ;
  }

  void didUpdateWidget(FilterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu selectedOptions đã được cập nhật, đổi isSelected thành true
    isSelected =
        widget.selectedOptions.values.any((value) => value != 'Loại sản phẩm');
  }

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
          OutlinedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2), // Điều chỉnh padding để làm nút nhỏ hơn
              ),
              minimumSize: MaterialStateProperty.all<Size>(
                Size(80, 30), // Đặt kích thước tối thiểu cho nút
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                  (Set<MaterialState> states) {
                return BorderSide(
                  color: isSelected
                      ? AppColor.primaryColor
                      : Colors.grey, // Viền màu khi không nhấn
                  width: 1,
                );
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return isSelected ? Colors.white : Colors.black;
              }),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return isSelected
                    ? AppColor.primaryColor.withOpacity(0.3)
                    : Colors.transparent; // Nền trong suốt khi chưa chọn
              }),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColor.primaryColor; // Màu overlay khi nhấn
                }
                return null;
              }),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              Map<String, String> tempSelectedOptions =
                  Map.from(widget.selectedOptions);

              showModalBottomSheet(
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
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        ChoiceChip(
                                            checkmarkColor: AppColor.extraColor,
                                            label: Text(
                                              'Tất cả',
                                              style: TextStyle(
                                                color: tempSelectedOptions[
                                                            filterOption
                                                                .title] ==
                                                        'Tất cả'
                                                    ? AppColor.extraColor
                                                    : Colors.black,
                                              ),
                                            ),
                                            selected: tempSelectedOptions[
                                                    filterOption.title] ==
                                                "Tất cả",
                                            onSelected: (selected) {
                                              setState(() {
                                                tempSelectedOptions[filterOption
                                                    .title] = "Tất cả";
                                                isSelected = false;
                                              });
                                              widget.onOptionSelected(
                                                  filterOption.title, "Tất cả");
                                              Navigator.pop(context);
                                            },
                                            selectedColor:
                                                AppColor.primaryColor),
                                        ...filterOption.options.map((option) {
                                          return ChoiceChip(
                                            checkmarkColor: AppColor.extraColor,
                                            selectedColor:
                                                AppColor.primaryColor,
                                            label: Text(
                                              option.name ?? '',
                                              style: TextStyle(
                                                color: tempSelectedOptions[
                                                            filterOption
                                                                .title] ==
                                                        option.name
                                                    ? AppColor.extraColor
                                                    : Colors.black,
                                              ),
                                            ),
                                            selected: tempSelectedOptions[
                                                    filterOption.title] ==
                                                option.name,
                                            onSelected: (selected) {
                                              setState(() {
                                                tempSelectedOptions[filterOption
                                                    .title] = option.name ?? '';
                                              });
                                              setState(() {
                                                isSelected = true;
                                              });
                                              widget.onOptionSelected(
                                                  filterOption.title,
                                                  option.name ?? '');
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                );
                              }).toList(),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: ElevatedButton(
                              //     onPressed: () {
                              //       tempSelectedOptions.forEach((key, value) {
                              //         widget.onOptionSelected(key, value);
                              //       });
                              //       Navigator.pop(context);
                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor: AppColor.primaryColor,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10),
                              //       ),
                              //     ),
                              //     child: Text(
                              //       'Xác nhận',
                              //       style:
                              //           TextStyle(color: AppColor.extraColor),
                              //     ),
                              //   ),
                              // ),
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
                  _getSelectedOptionsText(),
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
