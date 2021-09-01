SELECT * FROM project2.housingdata;



UPDATE housingdata
SET propertyaddress = NULL
WHERE propertyaddress like '';

-- populate property Id
select a.parcelid, a.propertyaddress,b.parcelid,b.propertyaddress, ifnull(a.propertyaddress,b.propertyaddress)
from housingdata a
join housingdata b
    on a.parcelid=b.parcelid
    and a.uniqueid<>b.uniqueid
where a.propertyaddress is null;

update a
set propertyadress= ifnull(a.propertyaddress,b.propertyaddress)
from housingdata a
join housingdata b
    on a.parcelid=b.parcelid
    and a.uniqueid<>b.uniqueid
where a.propertyaddress is null;

update housingdata
set propertyaddress= 'no address'
where propertyaddress is null;


-- breaking address into columns(address,city,state) 
select propertyaddress
from housingdata ;

select
substring(propertyaddress,1,instr(propertyaddress,',')-1) as address,
substring(propertyaddress,instr(propertyaddress,',')+1,length(propertyaddress)) as address
from housingdata;

 Alter table housingdata
 add propertysplitaddress nvarchar(255);
 update housingdata
 set propertysplitaddress=substring(propertyaddress,1,instr(propertyaddress,',')-1);
 
 Alter table housingdata
 add propertysplitcity nvarchar(255);
 update housingdata
 set propertysplitcity= substring(propertyaddress,instr(propertyaddress,',')+1,length(propertyaddress));
 
 SELECT * FROM project2.housingdata;
 
 -- breaking owners address
select
substring(owneraddress,1,instr(owneraddress,',')-1)as address,
substring(owneraddress,instr(owneraddress,',')+1,length(owneraddress)) as address,
substring(owneraddress,instr(owneraddress,','),length(owneraddress))
from housingdata;
select
substring_index(owneraddress,',',1),
substring_index(substring_index(owneraddress,',',2), ' ', -1),
substring_index(substring_index(owneraddress,',',3),' ', -1)
from housingdata;

-- adding columns and values
Alter table housingdata
 add ownersplitaddress nvarchar(255);
 update housingdata
 set ownersplitaddress=substring_index(owneraddress,',',1);
 
 Alter table housingdata
 add ownersplitcity nvarchar(255);
 update housingdata
 set ownersplitcity= substring_index(substring_index(owneraddress,',',2), ' ', -1);
 
 Alter table housingdata
 add ownersplitstate nvarchar(255);
 update housingdata
 set ownersplitstate=substring_index(substring_index(owneraddress,',',3),' ', -1);
 
 -- changing y and N to yes and no in sold as vacant field
 select distinct(soldasvacant),count(soldasvacant)
 from housingdata
 group by(soldasvacant)
 order by 2;
 
 select soldasvacant,
 case when soldasvacant='Y' then 'Yes'
      when soldasvacant='N' then 'No'
      else soldasvacant
      end
from housingdata;

update housingdata
set soldasvacant= case when soldasvacant='Y' then 'Yes'
      when soldasvacant='N' then 'No'
      else soldasvacant
      end;
      -- removing duplicates
      
with RowNumCTE as(
select *,
	row_number()over(
	partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by
		uniqueid
		)row_num
              
 from housingdata
 -- order by parcelid
   )           
 
select*
from RowNumCTE
where row_num>1
order by propertyaddress;
-- if there are write delete will delete them
-- deleting unused columns


alter table housingdata
drop column taxdistrict