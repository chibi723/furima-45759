## Tabel名: `users` (ユーザー)

|Column|Type|Options|
|------|----|-------|
| nickname | string | NOT NULL |
| email | string | NOT NULL, UNIQUE |
| encrypted_password | string | NOT NULL |
| first_name | string | NOT NULL |
| last_name | string | NOT NULL |
| first_name_kana | string | NOT NULL |
| last_name_kana | string | NOT NULL |
| birth_date | date | NOT NULL |

### Association
`has_many :items` (出品商品)
`has_many :orders` (購入履歴)

## Tabel名: `items` (商品)

|Column|Type|Options||
|------|----|-------|
| user | references | NOT NULL, FOREIGN KEY (users.id) |
| name | string | NOT NULL |
| info | text | NOT NULL |
| price | integer | NOT NULL |
| category_id | integer | NOT NULL (ActiveHash) |
| sales_status_id | integer | NOT NULL (ActiveHash) |
| shipping_fee_id | integer | NOT NULL (ActiveHash) |
| prefecture_id | integer | NOT NULL (ActiveHash) |
| scheduled_delivery_id | integer | NOT NULL (ActiveHash) |

### Association
`belongs_to :user` (出品者)
`has_one :order` (購入情報)

## Tabel名: `Purchase` (購入情報/取引記録)

|Column|Type|Options|
|------|----|-------|
| user | references | NOT NULL, FOREIGN KEY (users.id) |
| item | references | NOT NULL, FOREIGN KEY (items.id) |

### Association
`belongs_to :user` (購入者)
`belongs_to :item` (購入された商品)
`has_one :address` (配送先情報)

## Tabel名: `addresses` (配送先情報)

|Column|Type|Options|
|------|----|-------|
| order | references | NOT NULL, FOREIGN KEY (orders.id) |
| postal_code | string | NOT NULL |
| prefecture_id | integer | NOT NULL (ActiveHash) |
| city | string | NOT NULL |
| street_address | string | NOT NULL |
| building_name | string | NULLABLE |
| phone_number | string | NOT NULL |

### Association
`belongs_to :order` (購入取引)
