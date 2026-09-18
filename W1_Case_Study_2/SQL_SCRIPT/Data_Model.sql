-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema retaildw
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema retaildw
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `retaildw` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `retaildw` ;

-- -----------------------------------------------------
-- Table `retaildw`.`dimcustomer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retaildw`.`dimcustomer` (
  `CustomerID` VARCHAR(20) NOT NULL,
  `Gender` VARCHAR(20) NULL DEFAULT NULL,
  `Region` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retaildw`.`dimdate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retaildw`.`dimdate` (
  `DateID` INT NOT NULL AUTO_INCREMENT,
  `FullDate` DATE NULL DEFAULT NULL,
  `MonthName` VARCHAR(20) NULL DEFAULT NULL,
  `Month` INT NULL DEFAULT NULL,
  `Year` INT NULL DEFAULT NULL,
  PRIMARY KEY (`DateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retaildw`.`dimproduct`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retaildw`.`dimproduct` (
  `ProductID` INT NOT NULL,
  `ProductName` VARCHAR(255) NULL DEFAULT NULL,
  `Category` VARCHAR(100) NULL DEFAULT NULL,
  `Price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`ProductID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `retaildw`.`factsales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retaildw`.`factsales` (
  `SalesID` INT NOT NULL,
  `CustomerID` VARCHAR(20) NULL DEFAULT NULL,
  `ProductID` INT NULL DEFAULT NULL,
  `DateID` INT NULL DEFAULT NULL,
  `Quantity` INT NULL DEFAULT NULL,
  `SalesAmount` DECIMAL(12,2) NULL DEFAULT NULL,
  PRIMARY KEY (`SalesID`),
  INDEX `CustomerID` (`CustomerID` ASC) VISIBLE,
  INDEX `ProductID` (`ProductID` ASC) VISIBLE,
  INDEX `DateID` (`DateID` ASC) VISIBLE,
  CONSTRAINT `factsales_ibfk_1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `retaildw`.`dimcustomer` (`CustomerID`),
  CONSTRAINT `factsales_ibfk_2`
    FOREIGN KEY (`ProductID`)
    REFERENCES `retaildw`.`dimproduct` (`ProductID`),
  CONSTRAINT `factsales_ibfk_3`
    FOREIGN KEY (`DateID`)
    REFERENCES `retaildw`.`dimdate` (`DateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
