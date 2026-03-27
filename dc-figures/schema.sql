-- DC Comics Action Figures Database
-- Run: mysql -u root -p < schema.sql

CREATE DATABASE IF NOT EXISTS dc_figures;
USE dc_figures;

DROP TABLE IF EXISTS figures;

CREATE TABLE figures (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100)   NOT NULL,
  character   VARCHAR(100)   NOT NULL,
  series      VARCHAR(100)   NOT NULL,
  manufacturer VARCHAR(80)   NOT NULL,
  year        YEAR           NOT NULL,
  scale       VARCHAR(20)    NOT NULL,  -- e.g. '7-inch', '12-inch'
  universe    ENUM('New 52','Rebirth','Classic','Dark Multiverse','Elseworlds','Movie') NOT NULL,
  rarity      ENUM('Common','Uncommon','Rare','Ultra Rare') NOT NULL,
  price_usd   DECIMAL(8,2)   NOT NULL,
  in_stock    BOOLEAN        NOT NULL DEFAULT TRUE,
  accessories TEXT,
  INDEX idx_character (character),
  INDEX idx_series    (series),
  INDEX idx_year      (year),
  INDEX idx_rarity    (rarity),
  INDEX idx_universe  (universe)
);

INSERT INTO figures
  (name, character, series, manufacturer, year, scale, universe, rarity, price_usd, in_stock, accessories)
VALUES
-- Batman
('Batman Dark Knight Returns', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Classic', 'Rare', 34.99, TRUE, 'Batarang, cape, collector card'),
('Batman Zero Year', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'New 52', 'Common', 19.99, TRUE, 'Display base, collector card'),
('Batman Rebirth', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Batarang, base'),
('Batman Earth -22 Infected', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Dark Multiverse', 'Ultra Rare', 49.99, FALSE, 'Dark energy construct, base'),
('Batman 1966 TV Series', 'Batman', 'Retro 8-inch', 'Mego', 2020, '8-inch', 'Classic', 'Uncommon', 24.99, TRUE, 'Cloth costume, batarang, utility belt'),
('Batman Knightfall', 'Batman', 'DC Icons', 'DC Collectibles', 2017, '6-inch', 'Classic', 'Rare', 44.99, FALSE, 'Batarang, grapple gun, stand'),
('Batman Who Laughs', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Dark Multiverse', 'Ultra Rare', 59.99, FALSE, 'Dark Batmobile stand, robins'),
('Batman Flashpoint', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Classic', 'Uncommon', 21.99, TRUE, 'Two pistols, base'),
('Batman Suit of Sorrows', 'Batman', 'DC Multiverse', 'McFarlane Toys', 2023, '7-inch', 'Rebirth', 'Rare', 34.99, TRUE, 'Sword, shield, collector card'),

-- Superman
('Superman Red Son', 'Superman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Elseworlds', 'Rare', 34.99, TRUE, 'Hammer and sickle logo base'),
('Superman Action Comics #1000', 'Superman', 'DC Icons', 'DC Collectibles', 2018, '6-inch', 'Classic', 'Ultra Rare', 69.99, FALSE, 'Kryptonite, display stand'),
('Superman Rebirth', 'Superman', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Display base, collector card'),
('Superman Man of Steel Movie', 'Superman', 'Movie Masters', 'Mattel', 2013, '6-inch', 'Movie', 'Uncommon', 29.99, FALSE, 'Kryptonian armor stand'),
('Superman New 52', 'Superman', 'DC Collectibles', 'DC Collectibles', 2012, '6.75-inch', 'New 52', 'Uncommon', 27.99, TRUE, 'Base'),
('Superboy Prime', 'Superboy-Prime', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Classic', 'Rare', 34.99, FALSE, 'Construct, base'),

-- Wonder Woman
('Wonder Woman Rebirth', 'Wonder Woman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Sword, shield, lasso, base'),
('Wonder Woman 1984 Movie', 'Wonder Woman', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Movie', 'Uncommon', 24.99, TRUE, 'Golden armor, tiara, base'),
('Wonder Woman New 52', 'Wonder Woman', 'DC Icons', 'DC Collectibles', 2016, '6-inch', 'New 52', 'Rare', 39.99, FALSE, 'Sword, shield, lasso of truth'),
('Wonder Woman Classic', 'Wonder Woman', 'Retro 8-inch', 'Mego', 2019, '8-inch', 'Classic', 'Uncommon', 22.99, TRUE, 'Cloth costume, lasso, tiara'),

-- The Flash
('The Flash Rebirth', 'The Flash', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Lightning construct, base'),
('The Flash Dark Nights Metal', 'The Flash', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Dark Multiverse', 'Rare', 34.99, TRUE, 'Speed force energy, base'),
('Flash Flashpoint', 'The Flash', 'DC Icons', 'DC Collectibles', 2017, '6-inch', 'Classic', 'Uncommon', 29.99, FALSE, 'Speed force construct, stand'),
('Flash Classic TV Series', 'The Flash', 'Retro 8-inch', 'Mego', 2021, '8-inch', 'Classic', 'Uncommon', 22.99, TRUE, 'Cloth costume'),

-- Green Lantern
('Hal Jordan Rebirth', 'Green Lantern', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Green construct, ring, base'),
('John Stewart New 52', 'Green Lantern', 'DC Collectibles', 'DC Collectibles', 2014, '6.75-inch', 'New 52', 'Uncommon', 27.99, FALSE, 'Power battery, constructs'),
('Kyle Rayner Classic', 'Green Lantern', 'DC Icons', 'DC Collectibles', 2016, '6-inch', 'Classic', 'Rare', 44.99, FALSE, 'Lantern construct, stand'),
('Sinestro Classic', 'Sinestro', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Classic', 'Uncommon', 24.99, TRUE, 'Yellow construct, ring, base'),

-- Aquaman
('Aquaman Rebirth', 'Aquaman', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Trident, base'),
('Aquaman Movie', 'Aquaman', 'DC Multiverse', 'McFarlane Toys', 2018, '7-inch', 'Movie', 'Uncommon', 24.99, FALSE, 'Trident, ocean stand'),
('Black Manta Rebirth', 'Black Manta', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Rebirth', 'Uncommon', 21.99, TRUE, 'Jet pack, blasters, base'),

-- Villains
('The Joker Death of the Family', 'The Joker', 'DC Collectibles', 'DC Collectibles', 2013, '6.75-inch', 'New 52', 'Ultra Rare', 89.99, FALSE, 'Severed face accessory, knife, stand'),
('The Joker Rebirth', 'The Joker', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Crowbar, base'),
('Harley Quinn Classic', 'Harley Quinn', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Classic', 'Common', 19.99, TRUE, 'Mallet, pistol, base'),
('Harley Quinn Rebirth', 'Harley Quinn', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Bat, pistol, base'),
('Lex Luthor Apex Predator', 'Lex Luthor', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Rare', 34.99, FALSE, 'War suit parts, collector card'),
('Deathstroke Rebirth', 'Deathstroke', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Uncommon', 24.99, TRUE, 'Sword, pistol, staff, base'),
('Bane Knightfall', 'Bane', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Classic', 'Rare', 34.99, TRUE, 'Venom tube, base'),
('Darkseid Classic', 'Darkseid', 'DC Multiverse', 'McFarlane Toys', 2022, '10-inch', 'Classic', 'Ultra Rare', 79.99, FALSE, 'Omega beams, throne, base'),
('Doomsday New 52', 'Doomsday', 'DC Collectibles', 'DC Collectibles', 2014, '6.75-inch', 'New 52', 'Rare', 44.99, FALSE, 'Bone spurs, stand'),
('Brainiac New 52', 'Brainiac', 'DC Collectibles', 'DC Collectibles', 2013, '6.75-inch', 'New 52', 'Rare', 44.99, FALSE, 'Skull ship, stand'),
('Reverse Flash Rebirth', 'Reverse Flash', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Uncommon', 24.99, TRUE, 'Speed force energy, base'),
('Two-Face Classic', 'Two-Face', 'DC Multiverse', 'McFarlane Toys', 2023, '7-inch', 'Classic', 'Uncommon', 21.99, TRUE, 'Coin, pistols, base'),
('Scarecrow Rebirth', 'Scarecrow', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Rebirth', 'Uncommon', 21.99, TRUE, 'Fear toxin syringe, base'),
('Ra''s al Ghul Rebirth', 'Ra''s al Ghul', 'DC Multiverse', 'McFarlane Toys', 2023, '7-inch', 'Rebirth', 'Rare', 29.99, TRUE, 'Sword, Lazarus Pit vial'),
('Mr. Freeze Classic', 'Mr. Freeze', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Classic', 'Uncommon', 24.99, FALSE, 'Freeze gun, base'),

-- Justice League
('Cyborg Rebirth', 'Cyborg', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Sonic cannon, base'),
('Green Arrow Rebirth', 'Green Arrow', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Bow, arrows, quiver, base'),
('Black Canary Rebirth', 'Black Canary', 'DC Multiverse', 'McFarlane Toys', 2023, '7-inch', 'Rebirth', 'Uncommon', 24.99, TRUE, 'Sonic cry effect, base'),
('Martian Manhunter New 52', 'Martian Manhunter', 'DC Collectibles', 'DC Collectibles', 2014, '6.75-inch', 'New 52', 'Rare', 44.99, FALSE, 'Phase effect, stand'),
('Hawkman Rebirth', 'Hawkman', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Rebirth', 'Uncommon', 24.99, TRUE, 'Nth metal mace, wings, base'),
('Nightwing Rebirth', 'Nightwing', 'DC Multiverse', 'McFarlane Toys', 2020, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Dual escrima sticks, base'),
('Red Hood Rebirth', 'Red Hood', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Uncommon', 24.99, TRUE, 'Dual pistols, helmet, base'),
('Batgirl Rebirth', 'Batgirl', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Batarang, grapple gun, base'),
('Robin Damian Wayne', 'Robin', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Rebirth', 'Uncommon', 21.99, TRUE, 'Sword, base'),
('Shazam Rebirth', 'Shazam', 'DC Multiverse', 'McFarlane Toys', 2021, '7-inch', 'Rebirth', 'Common', 19.99, TRUE, 'Lightning construct, base'),
('Black Adam Classic', 'Black Adam', 'DC Multiverse', 'McFarlane Toys', 2022, '7-inch', 'Classic', 'Uncommon', 24.99, TRUE, 'Lightning, base'),
('Constantine Rebirth', 'John Constantine', 'DC Multiverse', 'McFarlane Toys', 2023, '7-inch', 'Rebirth', 'Rare', 29.99, TRUE, 'Cigarette effect, trench coat, briefcase');
