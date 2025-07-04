-- جدول الأغراض المعلقة للاستلام
CREATE TABLE IF NOT EXISTS `blackmarket_pending_pickups` (
    `identifier` varchar(50) NOT NULL,
    `item` varchar(50) NOT NULL,
    `amount` int(11) NOT NULL,
    `price` decimal(10,2) NOT NULL,
    `purchased_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`, `item`)
);

-- جدول العملة المشفرة
CREATE TABLE IF NOT EXISTS `phone_crypto` (
    `id` varchar(50) NOT NULL,
    `coin` varchar(50) NOT NULL,
    `amount` decimal(20,8) NOT NULL DEFAULT 0,
    `invested` decimal(20,8) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`, `coin`)
);

-- جدول تاريخ المعاملات
CREATE TABLE IF NOT EXISTS `blackmarket_transactions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `item` varchar(50) NOT NULL,
    `amount` int(11) NOT NULL,
    `price` decimal(10,2) NOT NULL,
    `type` enum('buy','sell') NOT NULL,
    `timestamp` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
);