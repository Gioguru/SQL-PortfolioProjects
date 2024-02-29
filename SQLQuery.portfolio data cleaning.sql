

/*

Cleaning data in SQL queries

*/

--We standardize the date format down below

Select SaleDateConverted, CONVERT(Date,Saledate)
FROM PortfolioProject..NashvileHousing

ALTER TABLE NashvileHousing
ADD SaleDateConverted Date;

Update NashvileHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate propery adress data

Select *
FROM PortfolioProject..NashvileHousing
--WHERE PropertyAddress IS NULL
order by ParcelID


Select a.ParcelID,a.PropertyAddress,b.PropertyAddress,b.ParcelID, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress,b.propertyaddress)
FROM PortfolioProject..NashvileHousing a
JOIN PortfolioProject..NashvileHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null


--Breaking out address into individual columns: address,city,state

Select PropertyAddress
FROM PortfolioProject..NashvileHousing
--WHERE PropertyAddress IS NULL
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1) as address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(propertyaddress)) as address
from PortfolioProject..NashvileHousing


ALTER TABLE NashvileHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvileHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',propertyaddress)-1) 

ALTER TABLE NashvileHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvileHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(propertyaddress))


SELECT *
FROM PortfolioProject..NashvileHousing







SELECT OwnerAddress
FROM PortfolioProject..NashvileHousing

SELECT
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvileHousing


ALTER TABLE NashvileHousing
ADD OwnerSplitAddress Nvarchar (255);

UPDATE NashvileHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

ALTER TABLE NashvileHousing
ADD OwnerSplitCity Nvarchar (255);

UPDATE NashvileHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)

ALTER TABLE NashvileHousing
ADD OwnerSplitState Nvarchar (255);

UPDATE NashvileHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

Select *
FROM PortfolioProject..NashvileHousing



--Change Y and N to Yes and No in "Sold as Vacant" Field

Select distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvileHousing
GROUP by SoldAsVacant
order by 2

SELECT SoldAsVacant
,CASE
	When SoldAsVacant ='N' Then 'NO'
	when SoldAsVacant ='Y' Then 'Yes'
	Else SoldAsVacant
END
FROM PortfolioProject..NashvileHousing

UPDATE NashvileHousing
SET SoldAsVacant = Case
	When SoldAsVacant ='N' Then 'NO'
	when SoldAsVacant ='Y' Then 'Yes'
	Else SoldAsVacant
END
FROM PortfolioProject..NashvileHousing


--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					)row_num
FROM PortfolioProject..NashvileHousing
--order by ParcelID
)

SELECT *
FROM RowNumCTE
where row_num > 1
order by propertyaddress


--Delete Unused Columns


Select *
FROM PortfolioProject..NashvileHousing

ALTER TABLE PortfolioProject..NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvileHousing
DROP COLUMN SaleDate