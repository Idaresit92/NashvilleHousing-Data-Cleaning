Cleaning Data in sql Queries
Select*
From Portfolioproject.dbo.NashvilleHousing

-- Standardize Date Format
Select SaleDateConverted, CONVERT (Date, SaleDate)
From Portfolioproject.dbo.NashvilleHousing

UPDATE Portfolioproject.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update Portfolioproject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data
Select PropertyAddress, CONVERT (Date, SaleDate)
From Portfolioproject.dbo.NashvilleHousing
Where propertyAddress is null

Select *
From Portfolioproject.dbo.NashvilleHousing
--Where propertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE (a.PropertyAddress, b.PropertyAddress)
From Portfolioproject.dbo.NashvilleHousing a
JOIN Portfolioproject.dbo.NashvilleHousing b
on a.parcelID = b.parcelID
And a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

Update a
SET PropertyAddress = COALESCE (a.PropertyAddress, b.PropertyAddress)
From Portfolioproject.dbo.NashvilleHousing a
JOIN Portfolioproject.dbo.NashvilleHousing b
on a.parcelID = b.parcelID
And a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, state)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) as Address,
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add PropertySplitAddress NVarchar(255);

Update Portfolioproject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add PropertySplitCity NVarchar (255);

Update Portfolioproject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME (Replace(OwnerAddress, ',','.'), 3)
,PARSENAME (Replace(OwnerAddress, ',','.'), 2)
,PARSENAME (Replace(OwnerAddress, ',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add OwnerSplitAddress NVarchar(255);

Update Portfolioproject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME (Replace(OwnerAddress, ',','.'), 3)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add OwnerSplitCity NVarchar (255);

Update Portfolioproject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME (Replace(OwnerAddress, ',','.'), 2)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
Add OwnerSplitState NVarchar (255);

Update Portfolioproject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME (Replace(OwnerAddress, ',','.'), 1)

Select *
From PortfolioProject.dbo.NashvilleHousing


--Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolioProject.dbo.NashvilleHousing
Group by SoldAsvacant
order by 2



Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
      When SoldAsVacant = 'N' THEN 'No'
	  Else SoldAsVacant
	  END
From portfolioProject.dbo.NashvilleHousing

Update portfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
        When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End


--Remove Duplicates

WITH RowNumCTE As(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



--Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress


