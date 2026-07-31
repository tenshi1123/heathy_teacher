import os

files = [
    'lib/utils/widget/custom_widget.dart',
    'lib/screens/splash/sale_screen.dart',
    'lib/screens/splash/list_class_online_external.dart',
    'lib/screens/splash/external_page.dart',
    'lib/screens/productPage/list_detail_product_screen.dart',
    'lib/screens/productPage/detail_product_screen.dart',
    'lib/screens/listSanPham/list_detail_sp.dart',
    'lib/screens/homePage/register_class_online.dart',
    'lib/screens/homePage/register_class.dart',
    'lib/screens/homePage/list_class_off.dart',
    'lib/screens/homePage/home_screen.dart'
]

for filepath in files:
    if os.path.exists(filepath):
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        for i, line in enumerate(lines):
            if 'TextDecoration.lineThrough' in line:
                start = max(0, i - 15)
                end = min(len(lines), i + 10)
                print(f'\n--- {filepath} (Line {i}) ---')
                for j in range(start, end):
                    print(lines[j].rstrip())
