# test
тестовое задание
Программист Delphi + MsSql
Тестовое задание (Складской учёт) 

Задача: 
Разработать простое приложение на Embarcadero Rad Studio Delphi 10.3.1. 
 (интерфейс минимальный; работа с компонетой FireDac;
 СУБД MsSql Express – 2014; сторонние библиотеки, не входящие в RAD Studio не использовать)
позволяющее вести простой складской количественно- суммовой учёт в разрезе партий и мест хранения на складах

# Товары:

Table Goods (можно расширять)

 [GoodsId]    	bigint          
 [GoodsName]  	nvarchar(100)   
 
+Ваши поля, если необходимо….

# Склады: 

Table Warehouse

 [WarehouseId]   	Bigint        
 [WarehouseName] 	nvarchar(100) 
 
+Ваши поля, если необходимо….

# Места хранения на складе: 

Table Place

 [PlaceId]     	bigint                        
 [WarehouseId] 	bigint, foreign key, not Null 
 
+Ваши поля, если необходимо….

Таблица Партий проектируется самостоятельно.
Механизм учета остатков проектируется самостоятельно.
Места хранения могут быть пустыми 
Партия может быть пустой.

Документы
1) Приход 
2) Перемещение 
3) Расход

Списание партий по FIFO и вручную
Остатки должны быть на Дату и на Время
Отчёт в виде остатков на определённое время и день и времени в Grid

Должен быть простой и эффективный, производительный код.
