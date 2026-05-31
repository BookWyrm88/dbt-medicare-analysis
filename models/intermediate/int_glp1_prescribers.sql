with glp1_drugs as (

    select *
    from {{ ref('stg_prescriber_drug') }}
    where generic_name in (
        'Dulaglutide',
        'Exenatide',
        'Exenatide Microspheres',
        'Liraglutide',
        'Semaglutide',
        'Tirzepatide'
    )

),

provider_totals as (

    select
        provider_npi,
        provider_last_org_name,
        provider_first_name,
        provider_city,
        provider_state,
        provider_specialty,
        sum(total_claims)           as total_glp1_claims,
        sum(total_beneficiaries)    as total_glp1_beneficiaries,
        count(distinct generic_name) as distinct_glp1_drugs

    from glp1_drugs
    group by
        provider_npi,
        provider_last_org_name,
        provider_first_name,
        provider_city,
        provider_state,
        provider_specialty

)

select * from provider_totals