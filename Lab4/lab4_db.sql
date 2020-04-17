-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Апр 17 2020 г., 19:55
-- Версия сервера: 10.4.11-MariaDB
-- Версия PHP: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+3:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `lab4_db`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_item` (IN `item_prod` INT UNSIGNED, IN `item_title` VARCHAR(200), IN `item_price` INT UNSIGNED)  begin
    insert ignore
    into goods_table
    value (null, item_prod, item_title, item_price);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_price` (IN `item_title` VARCHAR(200), IN `new_price` INT UNSIGNED)  begin
    update goods_table
        set price = new_price
    where title = item_title;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_item` (IN `item_title` VARCHAR(200))  begin
    delete from goods_table where title = item_title;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_items` (IN `query` VARCHAR(200), IN `min_price` INT UNSIGNED, IN `max_price` INT UNSIGNED)  begin
    select prod_id, title, price
    from goods_table
    where (title like concat('%', query, '%'))
    and (min_price = 0 or price >= min_price)
    and (max_price = 0 or price <= max_price);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all` ()  begin
    select prod_id, title, price from goods_table;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_by_price` (IN `l` INT UNSIGNED, IN `h` INT UNSIGNED)  begin
    select prod_id, title, price
    from goods_table
    where price >= l and price <= h;
end$$

--
-- Функции
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_price` (`item_title` VARCHAR(200)) RETURNS INT(11) begin
    declare c int;
    select price into c from goods_table where title = item_title;
    if c is null then
        return -1;
    else
        return c;
    end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `goods_table`
--

CREATE TABLE `goods_table` (
  `id` int(10) UNSIGNED NOT NULL,
  `prod_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(200) NOT NULL,
  `price` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Индексы таблицы `goods_table`
--

ALTER TABLE `goods_table`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `goods_table_title_uindex` (`title`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `goods_table`
--
ALTER TABLE `goods_table`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
