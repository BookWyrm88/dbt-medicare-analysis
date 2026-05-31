with provider_stats as (

    select *
    from {{ ref('int_glp1_prescribers') }}

),

specialty_stats as (

    select
        provider_specialty,
        avg(total_glp1_claims)                                    as avg_claims,
        stddev(total_glp1_claims)                                 as stddev_claims,
        count(distinct provider_npi)                              as provider_count

    from provider_stats
    group by provider_specialty

),

joined as (

    select
        p.provider_npi,
        p.provider_last_org_name,
        p.provider_first_name,
        p.provider_city,
        p.provider_state,
        p.provider_specialty,
        p.total_glp1_claims,
        p.total_glp1_beneficiaries,
        p.distinct_glp1_drugs,
        s.avg_claims,
        s.stddev_claims,
        s.provider_count,
        case
            when s.stddev_claims = 0 then 0
            else (p.total_glp1_claims - s.avg_claims) / s.stddev_claims
        end                                                       as z_score

    from provider_stats p
    left join specialty_stats s
        on p.provider_specialty = s.provider_specialty

),

final as (

    select
        *,
        case
            when z_score >= 3  then 'extreme_outlier'
            when z_score >= 2  then 'outlier'
            when z_score >= 1  then 'above_average'
            when z_score >= -1 then 'average'
            else 'below_average'
        end                                                       as prescribing_tier

    from joined
    where provider_count >= 10

)

select * from final
order by z_score desc