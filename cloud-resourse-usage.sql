create database cloud_analysis;
use cloud_analysis;
create table cloud_usage(
usage_id int auto_increment primary key	,
timestamp text,
cpu_usage double,
memory_usage double,
net_io double,
disk_io double,
cloud_provider varchar(50),
region varchar(100),
vm_type varchar(50),
vCPU int,
RAM_GB double,
price_per_hour double,
target varchar(100),
latency_ms double,
throughput double
);

alter table cloud_usage add column  cost double,add column utilization double;

select * from cloud_usage limit 10;

select count(*) as total_records from cloud_usage;

use cloud_analysis;

select distinct cloud_provider from cloud_usage;


select distinct region from cloud_usage;


select distinct vm_type from cloud_usage;

select min(cpu_usage) as minimum_cpu, 
max(cpu_usage)as maximum_cpu, 
avg(cpu_usage)as average_cpu from cloud_usage;



select min(memory_usage) as minimum_memory,
max(memory_usage)as maximum_memory,
avg(memory_usage)as average_memory 
from cloud_usage;

select cloud_provider as provider ,
 avg(cpu_usage) as average_cpu_usage from cloud_usage
 group by cloud_provider order by average_cpu_usage desc;

select region, avg(cpu_usage)as average_cpu_usage from cloud_usage group by region order by average_cpu_usage desc;

select vm_type,avg(price_per_hour) as average_price 
from cloud_usage group by vm_type 
order by average_price desc;

select cloud_provider,
avg(price_per_hour)as average_price 
from cloud_usage group by cloud_provider 
order by average_price desc;

select 
cloud_provider,count(*) as Total_Records 
from cloud_usage group by cloud_provider;

select region,count(*) as Total_Records from cloud_usage group by region;

select max(cpu_usage)as highest_cpu_usage from cloud_usage;
select min(cpu_usage)as lowest_cpu_usage from cloud_usage;

select sum(price_per_hour * 24)as estimated_daily_cost 
from cloud_usage;

select cloud_provider,sum(price_per_hour)as estimated_daily_cost from cloud_usage group by cloud_provider order by estimated_daily_cost desc ;

select cloud_provider, avg(cpu_usage)as average_cpu,
avg(memory_usage)as average_memory,
(avg(cpu_usage)+avg(memory_usage))/2 as overall_utilization 
from cloud_usage group by cloud_provider 
order by overall_utilization desc;

select 
      vm_type,
      avg(price_per_hour)as average_price,
      avg(cpu_usage)as average_cpu,
      avg(memory_usage) as average_memory,
      (avg(memory_usage)+avg(cpu_usage))/2 as overall_utilization from cloud_usage group by vm_type order by overall_utilization ;
      
      select 
            cloud_provider,
            avg(price_per_hour)as average_price,
            avg(cpu_usage)as average_cpu,
            avg(memory_usage)as average_memory,
            (avg(memory_usage)+avg(cpu_usage))/2 as overall_utilization from cloud_usage group by cloud_provider order by overall_utilization;

select 
      cloud_provider,
      avg(price_per_hour)as average_price_per_hour from cloud_usage group by cloud_provider order by average_price_per_hour desc;

select 
     region,
     avg(price_per_hour) as average_price_per_hour ,
     avg(cpu_usage)as average_cpu_usage,
     avg(memory_usage) as memory_usage,
     (avg(memory_usage)+avg(cpu_usage))/2  as overall_utilization 
     from cloud_usage group by region 
     order by overall_utilization desc;

select 
     usage_id,
     cloud_provider,
     region,
     vm_type,
     price_per_hour,
     cpu_usage,
     memory_usage
from cloud_usage
order by price_per_hour desc
limit 10;

select 
     usage_id,
     cloud_provider,
     region,
     vm_type,
     price_per_hour,
     cpu_usage,
     memory_usage,
     (cpu_usage+ memory_usage)/2 as overall_utilization
     from cloud_usage
     where (cpu_usage+memory_usage)/2<40
     order by price_per_hour desc;
     
select
      cloud_provider,
      count(*) as underutilized_resources
      from cloud_usage
      where (cpu_usage+memory_usage)/2<40
      group by cloud_provider
      order by underutilized_resources desc;
      
select
     vm_type,
     count(*) as underutilized_resources
     from cloud_usage
     where (cpu_usage+memory_usage)/2<40
     group by vm_type
     order by underutilized_resources desc;
     
select
     usage_id,
     cloud_provider,
     region,
     vm_type,
     price_per_hour,
     cpu_usage,
     memory_usage,
     (cpu_usage + memory_usage)/2 as overall_utilization
     from cloud_usage
     where price_per_hour >=0.04
     and(cpu_usage + memory_usage)/2<40
     order by overall_utilization ;
     
select 
      cloud_provider,
      count(*) as high_cost_low_optimization
      from cloud_usage
      where price_per_hour >= 0.04
      and (cpu_usage+memory_usage)/2 <40
      group by cloud_provider
      order by high_cost_low_optimization desc;
      
select
      cloud_provider,
      avg(latency_ms) as average_latency,
      avg(throughput)as average_throughput
      from cloud_usage
      group by cloud_provider
      order by average_latency asc;
      
create table virtual_machines (
          vm_id int auto_increment primary key,
          vm_type varchar(50),
          vCPU INT,
          RAM_GB DOUBLE);
          
show tables;
describe regions;
describe virtual_machines;
insert into regions(region_name)
select distinct region from cloud_usage;
select*from regions;
select*from virtual_machines;
      
insert into virtual_machines(vm_type,vCPU,RAM_GB)
select distinct 
           vm_type,
           vCPU,
           RAM_GB
from cloud_usage;

select*from virtual_machines;

truncate table virtual_machines;

select 
     c.usage_id,
     c.cloud_provider,
     c.cpu_usage,
     r.region_name,
     v.vm_type,
     v.vCPU,
     v.RAM_GB
     from cloud_usage c
     join regions r on c.region=r.region_name
     join virtual_machines v on c.vm_type = v.vm_type;
     
SELECT
    v.vm_type,
    v.vCPU,
    v.RAM_GB,
    AVG(c.price_per_hour) AS average_price,
    AVG(c.cpu_usage) AS average_cpu,
    AVG(c.memory_usage) AS average_memory
FROM cloud_usage c
JOIN virtual_machines v
    ON c.vm_type = v.vm_type
GROUP BY
    v.vm_type,
    v.vCPU,
    v.RAM_GB
ORDER BY average_price DESC;

SELECT
    r.region_name,
    v.vm_type,
    AVG(c.price_per_hour) AS average_price,
    (AVG(c.cpu_usage) + AVG(c.memory_usage)) / 2 AS overall_utilization
FROM cloud_usage c
JOIN regions r
    ON c.region = r.region_name
JOIN virtual_machines v
    ON c.vm_type = v.vm_type
GROUP BY
    r.region_name,
    v.vm_type
ORDER BY average_price DESC;

show tables;
select*from regions;
select*from virtual_machines;

SELECT 
    c.cloud_provider,
    p.provider_id,
    c.price_per_hour
FROM cloud_usage c
INNER JOIN cloud_providers p
ON c.cloud_provider = p.cloud_provider;

CREATE TABLE cloud_providers (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    cloud_provider VARCHAR(50)
);

INSERT INTO cloud_providers (cloud_provider)
VALUES
('AWS'),
('Azure'),
('GCP');
SELECT * FROM cloud_providers;

SELECT
    c.cloud_provider,
    p.provider_id,
    c.price_per_hour
FROM cloud_usage c
INNER JOIN cloud_providers p
ON c.cloud_provider = p.cloud_provider;
