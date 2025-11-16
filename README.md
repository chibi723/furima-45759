## Tabel名: `users` (ユーザー)

|Column|Type|Options|
|------|----|-------|
| id | BIGINT | PRIMARY KEY, NOT NULL |
| nickname | VARCHAR | NOT NULL |
| email | VARCHAR | NOT NULL, UNIQUE |
| encrypted_password | VARCHAR | NOT NULL |
| first_name | VARCHAR | NOT NULL |
| last_name | VARCHAR | NOT NULL |
| first_name_kana | VARCHAR | NOT NULL |
| last_name_kana | VARCHAR | NOT NULL |
| birth_date | DATE | NOT NULL |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### Association
`has_many :items` (出品商品)
`has_many :orders` (購入履歴)

## Tabel名: `items` (商品)

|Column|Type|Options||
|------|----|-------|
| id | BIGINT | PRIMARY KEY, NOT NULL |
| user_id | BIGINT | NOT NULL, FOREIGN KEY (users.id) |
| name | VARCHAR | NOT NULL |
| info | TEXT | NOT NULL |
| price | INTEGER | NOT NULL |
| category_id | INTEGER | NOT NULL (ActiveHash) |
| sales_status_id | INTEGER | NOT NULL (ActiveHash) |
| shipping_fee_id | INTEGER | NOT NULL (ActiveHash) |
| prefecture_id | INTEGER | NOT NULL (ActiveHash) |
| scheduled_delivery_id | INTEGER | NOT NULL (ActiveHash) |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### Association
`belongs_to :user` (出品者)
`has_one :order` (購入情報)
`belongs_to :category` (ActiveHash)

## Tabel名: `Purchase` (購入情報/取引記録)

|Column|Type|Options|
|------|----|-------|
| id | BIGINT | PRIMARY KEY, NOT NULL |
| user_id | BIGINT | NOT NULL, FOREIGN KEY (users.id) |
| item_id | BIGINT | NOT NULL, FOREIGN KEY (items.id), UNIQUE |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### Association
`belongs_to :user` (購入者)
`belongs_to :item` (購入された商品)
`has_one :address` (配送先情報)

## Tabel名: `addresses` (配送先情報)

|Column|Type|Options|
|------|----|-------|
| id | BIGINT | PRIMARY KEY, NOT NULL |
| order_id | BIGINT | NOT NULL, FOREIGN KEY (orders.id), UNIQUE |
| postal_code | VARCHAR | NOT NULL |
| prefecture_id | INTEGER | NOT NULL (ActiveHash) |
| city | VARCHAR | NOT NULL |
| street_address | VARCHAR | NOT NULL |
| building_name | VARCHAR | NULLABLE |
| phone_number | VARCHAR | NOT NULL |
| created_at | DATETIME | NOT NULL |
| updated_at | DATETIME | NOT NULL |

### Association
`belongs_to :order` (購入取引)
`belongs_to :prefecture` (ActiveHash)
