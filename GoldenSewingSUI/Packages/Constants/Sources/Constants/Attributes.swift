public enum Attributes: String {
    case cloth = "Ткань"
    case product = "Способ изготовления"
    case inlay = "Инкрустация"
    case size = "Размеры"
    case wdth = "Ширина"
    case clr = "Цвет"
    
    public static let clothDict = [
        "cloth_1" : "Атлас",
        "cloth_2" : "Атлас на натуральной основе",
        "cloth_3" : "Велюр",
        "cloth_4" : "Габардин",
        "cloth_5" : "Греческая тисненная парча",
        "cloth_6" : "Греческий галун",
        "cloth_7" : "Лен",
        "cloth_8" : "Муар",
        "cloth_9" : "Органза",
        "cloth_10": "Парча",
        "cloth_11": "Ткань заказчика",
        "cloth_12" : "Х/б бархат",
        "cloth_13" : "Хлопок",
        "cloth_14" : "Церковный жаккард",
        "cloth_15" : "Шелк",
        "cloth_16" : "Оксфорд",
        "cloth_17" : "Рогожка"
    ]
    
    public static let productDict = [
        "product_1" : "Гладь по настилу",
        "product_2" : "Золотая и серебряная канитель",
        "product_3" : "Золотая и цветная канитель",
        "product_4" : "Золотая канитель",
        "product_5" : "Золотая, серебряная и цветная канитель",
        "product_6" : "Машинная вышивка",
        "product_7" : "Метанит",
        "product_8" : "Ручная инкрустация канителью",
        "product_9" : "Ручное шитье",
        "product_10": "Серебряная канитель",
        "product_12": "Трунцал",
        "product_13": "Цветной метатнит",
        "product_14": "Шелк",
        "product_15": "Тканная вышивка",
        "product_16": "Акрил"
    ]
    
    public static let inlayDict = [
        "inlay_1" : "Агат",
        "inlay_2" : "Аметист",
        "inlay_3" : "Аметисты граненные в оправе",
        "inlay_4" : "Аметисты шлифованные",
        "inlay_5" : "Берилл",
        "inlay_6" : "Бирюза",
        "inlay_7" : "Бисер",
        "inlay_8" : "Горный хрусталь",
        "inlay_9" : "Гранат",
        "inlay_10": "Гранаты граненные в оправе",
        "inlay_11": "Гранаты шлифованные в оправе",
        "inlay_12": "Жемчуг",
        "inlay_13": "Кораллы",
        "inlay_14": "Лабрадор",
        "inlay_15": "Лазурит",
        "inlay_16": "Малахит",
        "inlay_17": "Нефрит",
        "inlay_17_1": "Изумруд",
        "inlay_18": "Оливин",
        "inlay_19": "Оникс",
        "inlay_20": "Родонит",
        "inlay_21": "Рубин",
        "inlay_21_1": "Селенит",
        "inlay_22": "Сердолик",
        "inlay_23": "Серпантинит",
        "inlay_24": "Стразы «Сваровски»",
        "inlay_25": "Топаз",
        "inlay_26": "Топазы в серебряной оправе",
        "inlay_27": "Турмалин",
        "inlay_28": "Хризолит",
        "inlay_29": "Хризопразы",
        "inlay_30" : "Цирконий",
        "inlay_31": "Цирконий в серебряной оправе",
        "inlay_32" : "Цитрин",
        "inlay_33": "Черный кварц",
        "inlay_34" : "Яшма",
        "elements_1": "Кант – голубая норка",
        "elements_2": "Кант – норка",
        "elements_3": "Кант – ручная вязка метанитом",
        "elements_4": "Крест ювелирной работы («Золотое шитье»)",
        "elements_5": "Крест ювелирной работы («Софрино»)",
        "elements_6": "Крест ювелирной работы",
        "icon_1" : "Живопись темперой",
        "icon_2" : "Иконы - вышивка золотым, серебряным и цветным метанитом",
        "icon_3" : "Иконы - вышивка канителью",
        "icon_4" : "Иконы - живопись по латуни",
        "icon_5" : "Иконы - золотой и серебряный метанит",
        "icon_6" : "Иконы - лаковая миниатюра",
        "icon_7" : "Иконы - лаковая миниатюра по дереву («Золотое шитье»)",
        "icon_8" : "Иконы - литография",
        "icon_9" : "Иконы - полимерная литография",
        "icon_10": "Иконы - ювелирные рамки, латунь, золочение",
        "icon_11": "Иконы - ювелирные рамки, латунь, серебрение",
        "icon_12": "Иконы предоставлены заказчиком",
        "icon_13": "Лаковая миниатюра, лазерное напыление",
        "icon_14": "Лаковая миниатюра, иконопись на сусальном золоте"
    ]
    
    public static let sizeDict = [
        "size_1" : "от 80 - 86 (1 - 1,5 года)"
    ]
    
    public static let colorDict = [
        "color_1" : "Белый",
        "color_2" : "Белый + золото",
        "color_3" : "Белый + серебро",
        "color_3_1" : "Бежевый",
        "color_3_2" : "Бежевый + золото",
        "color_3_3" : "Бежевый + серебро",
        "color_4" : "Бордо",
        "color_5" : "Бордо + золото",
        "color_6" : "Бордо + серебро",
        "color_6_1" : "Вишневый",
        "color_6_2" : "Вишневый + золото",
        "color_6_3" : "Вишневый + серебро",
        "color_7" : "Голубой",
        "color_8" : "Голубой + золото",
        "color_9" : "Голубой + серебро",
        "color_10" : "Желтый",
        "color_10_1" : "Желтый + золото",
        "color_10_2" : "Желтый + серебро",
        "color_10_3" : "Желтый + золото + горчица",
        "color_11" : "Зеленый",
        "color_12" : "Зеленый + золото",
        "color_13" : "Зеленый + серебро",
        "color_14" : "Красный",
        "color_15" : "Красный + золото",
        "color_16" : "Красный + серебро",
        "color_17" : "Фиолетовый",
        "color_18" : "Фиолетовый + золото",
        "color_19" : "Фиолетовый + серебро",
        "color_20" : "Черный",
        "color_21" : "Черный + золото",
        "color_22" : "Черный + серебро"
    ]
}
