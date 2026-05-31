with source as (

    select * from {{ source('medicare', 'prescriber_drug_raw') }}

),

renamed as (

    select
        Prscrbr_NPI                 as provider_npi,
        Prscrbr_Last_Org_Name       as provider_last_org_name,
        Prscrbr_First_Name          as provider_first_name,
        Prscrbr_City                as provider_city,
        Prscrbr_State_Abrvtn        as provider_state,
        Prscrbr_Type                as provider_specialty,
        Brnd_Name                   as brand_name,
        Gnrc_Name                   as generic_name,
        Tot_Clms                    as total_claims,
        Tot_Day_Suply               as total_day_supply,
        Tot_Benes                   as total_beneficiaries

    from source
    where Prscrbr_NPI is not null

)

select * from renamed