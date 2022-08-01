--Data Cleaning

Select * 
FROM [Portfolio Project]..NashvilleHousing	


-- Standardize date

Select SaleDate,CONVERT(Date,SaleDate)
From [Portfolio Project]..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,saleDate)

ALter TABLE NashvilleHousing
Add SaleDateConverted Date;
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted,CONVERT(Date,SaleDate)
From [Portfolio Project]..NashvilleHousing


--Populated Property Addresses

Select *
From [Portfolio Project]..NashvilleHousing
Where PropertyAddress is null

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID =b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
SET a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID =b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is Null


--Breaking out Address int individual coulmns

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing
--breaking out city and address
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
From [Portfolio Project]..NashvilleHousing


--create new coulmns for address and city
ALter TABLE NashvilleHousing
Add AddressSeparated VARCHAR(255);

--Update new coulmns for address and city
Update NashvilleHousing
SET AddressSeparated = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



ALter TABLE NashvilleHousing
Add CitySeparated VARCHAR(255);
Update NashvilleHousing
SET CitySeparated = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


--View ney address and City
SELECT *
From [Portfolio Project]..NashvilleHousing
Where SoldAsVacant = 'N'


--separate Owner address
SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS OwnerAddressSplit,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS OwnerCitySplit,
PARSENAME(REPLACE(OwnerAddress,',','.'),1)AS OwnerStateSplit
From [Portfolio Project]..NashvilleHousing


--CREATE Coulmns for Split Owner Address and Updated them 
ALter TABLE NashvilleHousing
Add SplitOwnerAddress VARCHAR(255);

UPDATE NashvilleHousing
SET SplitOwnerAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALter TABLE NashvilleHousing
Add SplitOwnerCity VARCHAR(255);

UPDATE NashvilleHousing
SET SplitOwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALter TABLE NashvilleHousing
Add SplitOwnerState VARCHAR(255);

UPDATE NashvilleHousing
SET SplitOwnerstate=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select OwnerAddress,SplitOwnerAddress,SplitOwnerCity,SplitOwnerstate
FROM [Portfolio Project]..NashvilleHousing


Update NashvilleHousingSET SoldAsVacant='No'
Where SoldAsVacant='N'

Update NashvilleHousing
SET SoldAsVacant='Yes'
Where SoldAsVacant='Y'
Select SoldASVacant
From [Portfolio Project]..NashvilleHousing
Where SoldAsVacant ='Y' 

Select DISTINCT(SoldAsVacant),Count(SoldAsVacant)
From  [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant



--Remove Duplicates
WITH RowNumCTE AS(
SELECT * ,
	ROW_NUMBER() OVER (
	PARTITION BY
			ParcelID, 
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order BY 
			UniqueID) row_num
					   

From [Portfolio Project]..NashvilleHousing
--Order BY ParcelID
)
SELECT *
--DELETE
FROM RowNumCTE
WHERE row_num >1
--ORDER BY PropertyAddress


---DELETE Unused Coulmns

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress,TaxDistrict

Select * 
FROM [Portfolio Project]..NashvilleHousing	