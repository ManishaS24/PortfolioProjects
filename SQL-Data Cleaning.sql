/*
Cleaning Data in SQLQuery
*/

USE PortfolioProjects

SELECT *
FROM PortfolioProjects..NashvilleHousing

-------------------------------------------------------------------------------------------------------
---- Standerdize DATE Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProjects..NashvilleHousing

--Update PortfolioProjects.dbo.NashVilleHousing
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashVilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--------------------------------------------------------------------------------------------------------------
---- Populate Property Address Data

/*
SELECT * 
FROM PortfolioProjects..NashvilleHousing
--WHERE PropertyAddress is NULL
ORDER BY ParcelID
*/

SELECT Self1.ParcelID, Self1.PropertyAddress, Self2.ParcelID, Self2.PropertyAddress, ISNULL(Self1.PropertyAddress, Self2.PropertyAddress)
FROM PortfolioProjects..NashvilleHousing AS Self1
JOIN PortfolioProjects..NashvilleHousing AS Self2
	ON Self1.ParcelID = Self2.ParcelID
	AND Self1.[UniqueID ] <> Self2.[UniqueID ]
WHERE Self1.PropertyAddress is NULL
--ORDER By ParcelID

UPDATE Self1
SET PropertyAddress = ISNULL(Self1.PropertyAddress, Self2.PropertyAddress)
FROM PortfolioProjects..NashvilleHousing AS Self1
JOIN PortfolioProjects..NashvilleHousing AS Self2
	ON Self1.ParcelID = Self2.ParcelID
	AND Self1.[UniqueID ] <> Self2.[UniqueID ]
WHERE Self1.PropertyAddress is NULL


--------------------------------------------------------------------------------------------------------
----  Breaking out Address into Individual Columns (Address, State, City)
----  Breaking out the Property Address

SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Adrress,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
FROM PortfolioProjects..NashvilleHousing


ALTER TABLE PortfolioProjects..NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

ALTER TABLE PortfolioProjects..NashvilleHousing
ADD PropertySplitCity nvarchar(255)

Update PortfolioProjects..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

Update PortfolioProjects..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


----  Breaking out the Owner Address

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as Address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as State
FROM PortfolioProjects..NashvilleHousing


ALTER TABLE PortfolioProjects..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

ALTER TABLE PortfolioProjects..NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

ALTER TABLE PortfolioProjects..NashvilleHousing
ADD OwnerplitState nvarchar(255)

Update PortfolioProjects..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Update PortfolioProjects..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Update PortfolioProjects..NashvilleHousing
SET OwnerplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)