--- Cleaning Data using Sql Queries 
USE PortfolioProject
select * 
from NashvilleHousing

--- Standardize Date format
select SaleDate, CONVERT(date,saledate) As Date
from NashvilleHousing

Alter Table NashvilleHousing
Add ConvertedSalesDate Date

Update NashvilleHousing
SET ConvertedSalesDate = CONVERT(date,saledate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select * from NashvilleHousing
--where PropertyAddress is Null
order by ParcelID


Select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b on
a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NUll

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b 
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NUll

-------------------------------------------------------------------------------------------------------------------------

-- Breaking Address into Individual Columns (Address, City, State)

Select PropertyAddress from NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as Address
from NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))

Select * from NashvilleHousing

Select OwnerAddress from NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',','.'),3),
PARSENAME(Replace(OwnerAddress, ',','.'),2),
PARSENAME(Replace(OwnerAddress, ',','.'),1)
from NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant
Order by 2

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END
from NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
With ROWNUMCTE AS(
Select *,
	ROW_NUMBER() Over
	(Partition by ParcelId,
				 PropertyAddress, 
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by UniqueID
				 )row_num
from NashvilleHousing
--Order by ParcelID
)
Delete from ROWNUMCTE
Where row_num >1
--Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select * from NashvilleHousing

Alter table NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress


Alter table NashvilleHousing
Drop Column SaleDate