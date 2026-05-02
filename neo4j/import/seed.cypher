CREATE CONSTRAINT gsp_id IF NOT EXISTS FOR (g:GridSupplyPoint) REQUIRE g.gsp_id IS UNIQUE;
CREATE CONSTRAINT substation_id IF NOT EXISTS FOR (s:Substation) REQUIRE s.substation_id IS UNIQUE;
CREATE CONSTRAINT feeder_id IF NOT EXISTS FOR (f:Feeder) REQUIRE f.feeder_id IS UNIQUE;
CREATE CONSTRAINT transformer_id IF NOT EXISTS FOR (t:Transformer) REQUIRE t.asset_id IS UNIQUE;
CREATE CONSTRAINT meter_id IF NOT EXISTS FOR (m:SmartMeter) REQUIRE m.meter_id IS UNIQUE;

MERGE (g:GridSupplyPoint {gsp_id: "GSP_NORTH"})
SET g.name = "Northern Grid Supply Point", g.voltage_kv = 132, g.region = "North Metro";

MERGE (s:Substation {substation_id: "SS_001"})
SET s.name = "Substation 1", s.voltage_kv = 11, s.region = "Region 1";

MERGE (f:Feeder {feeder_id: "F_001"})
SET f.name = "Feeder 1", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_001"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 1.9}]->(s);

MATCH (s:Substation {substation_id: "SS_001"}), (f:Feeder {feeder_id: "F_001"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 920}]->(f);

MERGE (t:Transformer {asset_id: "TX_001"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_001"}), (t:Transformer {asset_id: "TX_001"})
MERGE (f)-[:CONNECTS_TO {distance_m: 205}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00001"})
SET m.premise_id = "PREM_00001", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_001"}), (m:SmartMeter {meter_id: "SM_00001"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00002"})
SET m.premise_id = "PREM_00002", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_001"}), (m:SmartMeter {meter_id: "SM_00002"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00003"})
SET m.premise_id = "PREM_00003", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_001"}), (m:SmartMeter {meter_id: "SM_00003"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00004"})
SET m.premise_id = "PREM_00004", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_001"}), (m:SmartMeter {meter_id: "SM_00004"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00005"})
SET m.premise_id = "PREM_00005", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_001"}), (m:SmartMeter {meter_id: "SM_00005"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_002"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_001"}), (t:Transformer {asset_id: "TX_002"})
MERGE (f)-[:CONNECTS_TO {distance_m: 210}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00006"})
SET m.premise_id = "PREM_00006", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_002"}), (m:SmartMeter {meter_id: "SM_00006"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00007"})
SET m.premise_id = "PREM_00007", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_002"}), (m:SmartMeter {meter_id: "SM_00007"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00008"})
SET m.premise_id = "PREM_00008", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_002"}), (m:SmartMeter {meter_id: "SM_00008"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00009"})
SET m.premise_id = "PREM_00009", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_002"}), (m:SmartMeter {meter_id: "SM_00009"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00010"})
SET m.premise_id = "PREM_00010", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_002"}), (m:SmartMeter {meter_id: "SM_00010"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_003"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_001"}), (t:Transformer {asset_id: "TX_003"})
MERGE (f)-[:CONNECTS_TO {distance_m: 215}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00011"})
SET m.premise_id = "PREM_00011", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_003"}), (m:SmartMeter {meter_id: "SM_00011"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00012"})
SET m.premise_id = "PREM_00012", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_003"}), (m:SmartMeter {meter_id: "SM_00012"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00013"})
SET m.premise_id = "PREM_00013", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_003"}), (m:SmartMeter {meter_id: "SM_00013"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00014"})
SET m.premise_id = "PREM_00014", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_003"}), (m:SmartMeter {meter_id: "SM_00014"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00015"})
SET m.premise_id = "PREM_00015", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_003"}), (m:SmartMeter {meter_id: "SM_00015"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_004"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_001"}), (t:Transformer {asset_id: "TX_004"})
MERGE (f)-[:CONNECTS_TO {distance_m: 220}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00016"})
SET m.premise_id = "PREM_00016", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_004"}), (m:SmartMeter {meter_id: "SM_00016"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00017"})
SET m.premise_id = "PREM_00017", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_004"}), (m:SmartMeter {meter_id: "SM_00017"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00018"})
SET m.premise_id = "PREM_00018", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_004"}), (m:SmartMeter {meter_id: "SM_00018"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00019"})
SET m.premise_id = "PREM_00019", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_004"}), (m:SmartMeter {meter_id: "SM_00019"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00020"})
SET m.premise_id = "PREM_00020", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_004"}), (m:SmartMeter {meter_id: "SM_00020"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_002"})
SET s.name = "Substation 2", s.voltage_kv = 11, s.region = "Region 2";

MERGE (f:Feeder {feeder_id: "F_002"})
SET f.name = "Feeder 2", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_002"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 2.3}]->(s);

MATCH (s:Substation {substation_id: "SS_002"}), (f:Feeder {feeder_id: "F_002"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 940}]->(f);

MERGE (t:Transformer {asset_id: "TX_005"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_002"}), (t:Transformer {asset_id: "TX_005"})
MERGE (f)-[:CONNECTS_TO {distance_m: 225}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00021"})
SET m.premise_id = "PREM_00021", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_005"}), (m:SmartMeter {meter_id: "SM_00021"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00022"})
SET m.premise_id = "PREM_00022", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_005"}), (m:SmartMeter {meter_id: "SM_00022"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00023"})
SET m.premise_id = "PREM_00023", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_005"}), (m:SmartMeter {meter_id: "SM_00023"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00024"})
SET m.premise_id = "PREM_00024", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_005"}), (m:SmartMeter {meter_id: "SM_00024"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00025"})
SET m.premise_id = "PREM_00025", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_005"}), (m:SmartMeter {meter_id: "SM_00025"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_006"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_002"}), (t:Transformer {asset_id: "TX_006"})
MERGE (f)-[:CONNECTS_TO {distance_m: 230}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00026"})
SET m.premise_id = "PREM_00026", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_006"}), (m:SmartMeter {meter_id: "SM_00026"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00027"})
SET m.premise_id = "PREM_00027", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_006"}), (m:SmartMeter {meter_id: "SM_00027"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00028"})
SET m.premise_id = "PREM_00028", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_006"}), (m:SmartMeter {meter_id: "SM_00028"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00029"})
SET m.premise_id = "PREM_00029", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_006"}), (m:SmartMeter {meter_id: "SM_00029"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00030"})
SET m.premise_id = "PREM_00030", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_006"}), (m:SmartMeter {meter_id: "SM_00030"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_007"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_002"}), (t:Transformer {asset_id: "TX_007"})
MERGE (f)-[:CONNECTS_TO {distance_m: 235}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00031"})
SET m.premise_id = "PREM_00031", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_007"}), (m:SmartMeter {meter_id: "SM_00031"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00032"})
SET m.premise_id = "PREM_00032", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_007"}), (m:SmartMeter {meter_id: "SM_00032"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00033"})
SET m.premise_id = "PREM_00033", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_007"}), (m:SmartMeter {meter_id: "SM_00033"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00034"})
SET m.premise_id = "PREM_00034", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_007"}), (m:SmartMeter {meter_id: "SM_00034"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00035"})
SET m.premise_id = "PREM_00035", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_007"}), (m:SmartMeter {meter_id: "SM_00035"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_008"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_002"}), (t:Transformer {asset_id: "TX_008"})
MERGE (f)-[:CONNECTS_TO {distance_m: 240}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00036"})
SET m.premise_id = "PREM_00036", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_008"}), (m:SmartMeter {meter_id: "SM_00036"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00037"})
SET m.premise_id = "PREM_00037", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_008"}), (m:SmartMeter {meter_id: "SM_00037"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00038"})
SET m.premise_id = "PREM_00038", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_008"}), (m:SmartMeter {meter_id: "SM_00038"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00039"})
SET m.premise_id = "PREM_00039", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_008"}), (m:SmartMeter {meter_id: "SM_00039"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00040"})
SET m.premise_id = "PREM_00040", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_008"}), (m:SmartMeter {meter_id: "SM_00040"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_003"})
SET s.name = "Substation 3", s.voltage_kv = 11, s.region = "Region 3";

MERGE (f:Feeder {feeder_id: "F_003"})
SET f.name = "Feeder 3", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_003"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 2.7}]->(s);

MATCH (s:Substation {substation_id: "SS_003"}), (f:Feeder {feeder_id: "F_003"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 960}]->(f);

MERGE (t:Transformer {asset_id: "TX_009"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_003"}), (t:Transformer {asset_id: "TX_009"})
MERGE (f)-[:CONNECTS_TO {distance_m: 245}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00041"})
SET m.premise_id = "PREM_00041", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_009"}), (m:SmartMeter {meter_id: "SM_00041"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00042"})
SET m.premise_id = "PREM_00042", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_009"}), (m:SmartMeter {meter_id: "SM_00042"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00043"})
SET m.premise_id = "PREM_00043", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_009"}), (m:SmartMeter {meter_id: "SM_00043"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00044"})
SET m.premise_id = "PREM_00044", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_009"}), (m:SmartMeter {meter_id: "SM_00044"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00045"})
SET m.premise_id = "PREM_00045", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_009"}), (m:SmartMeter {meter_id: "SM_00045"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_010"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_003"}), (t:Transformer {asset_id: "TX_010"})
MERGE (f)-[:CONNECTS_TO {distance_m: 250}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00046"})
SET m.premise_id = "PREM_00046", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_010"}), (m:SmartMeter {meter_id: "SM_00046"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00047"})
SET m.premise_id = "PREM_00047", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_010"}), (m:SmartMeter {meter_id: "SM_00047"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00048"})
SET m.premise_id = "PREM_00048", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_010"}), (m:SmartMeter {meter_id: "SM_00048"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00049"})
SET m.premise_id = "PREM_00049", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_010"}), (m:SmartMeter {meter_id: "SM_00049"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00050"})
SET m.premise_id = "PREM_00050", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_010"}), (m:SmartMeter {meter_id: "SM_00050"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_011"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_003"}), (t:Transformer {asset_id: "TX_011"})
MERGE (f)-[:CONNECTS_TO {distance_m: 255}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00051"})
SET m.premise_id = "PREM_00051", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_011"}), (m:SmartMeter {meter_id: "SM_00051"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00052"})
SET m.premise_id = "PREM_00052", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_011"}), (m:SmartMeter {meter_id: "SM_00052"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00053"})
SET m.premise_id = "PREM_00053", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_011"}), (m:SmartMeter {meter_id: "SM_00053"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00054"})
SET m.premise_id = "PREM_00054", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_011"}), (m:SmartMeter {meter_id: "SM_00054"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00055"})
SET m.premise_id = "PREM_00055", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_011"}), (m:SmartMeter {meter_id: "SM_00055"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_012"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_003"}), (t:Transformer {asset_id: "TX_012"})
MERGE (f)-[:CONNECTS_TO {distance_m: 260}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00056"})
SET m.premise_id = "PREM_00056", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_012"}), (m:SmartMeter {meter_id: "SM_00056"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00057"})
SET m.premise_id = "PREM_00057", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_012"}), (m:SmartMeter {meter_id: "SM_00057"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00058"})
SET m.premise_id = "PREM_00058", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_012"}), (m:SmartMeter {meter_id: "SM_00058"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00059"})
SET m.premise_id = "PREM_00059", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_012"}), (m:SmartMeter {meter_id: "SM_00059"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00060"})
SET m.premise_id = "PREM_00060", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_012"}), (m:SmartMeter {meter_id: "SM_00060"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_004"})
SET s.name = "Substation 4", s.voltage_kv = 11, s.region = "Region 1";

MERGE (f:Feeder {feeder_id: "F_004"})
SET f.name = "Feeder 4", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_004"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 3.1}]->(s);

MATCH (s:Substation {substation_id: "SS_004"}), (f:Feeder {feeder_id: "F_004"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 980}]->(f);

MERGE (t:Transformer {asset_id: "TX_013"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_004"}), (t:Transformer {asset_id: "TX_013"})
MERGE (f)-[:CONNECTS_TO {distance_m: 265}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00061"})
SET m.premise_id = "PREM_00061", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_013"}), (m:SmartMeter {meter_id: "SM_00061"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00062"})
SET m.premise_id = "PREM_00062", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_013"}), (m:SmartMeter {meter_id: "SM_00062"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00063"})
SET m.premise_id = "PREM_00063", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_013"}), (m:SmartMeter {meter_id: "SM_00063"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00064"})
SET m.premise_id = "PREM_00064", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_013"}), (m:SmartMeter {meter_id: "SM_00064"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00065"})
SET m.premise_id = "PREM_00065", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_013"}), (m:SmartMeter {meter_id: "SM_00065"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_014"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_004"}), (t:Transformer {asset_id: "TX_014"})
MERGE (f)-[:CONNECTS_TO {distance_m: 270}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00066"})
SET m.premise_id = "PREM_00066", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_014"}), (m:SmartMeter {meter_id: "SM_00066"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00067"})
SET m.premise_id = "PREM_00067", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_014"}), (m:SmartMeter {meter_id: "SM_00067"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00068"})
SET m.premise_id = "PREM_00068", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_014"}), (m:SmartMeter {meter_id: "SM_00068"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00069"})
SET m.premise_id = "PREM_00069", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_014"}), (m:SmartMeter {meter_id: "SM_00069"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00070"})
SET m.premise_id = "PREM_00070", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_014"}), (m:SmartMeter {meter_id: "SM_00070"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_015"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_004"}), (t:Transformer {asset_id: "TX_015"})
MERGE (f)-[:CONNECTS_TO {distance_m: 275}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00071"})
SET m.premise_id = "PREM_00071", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_015"}), (m:SmartMeter {meter_id: "SM_00071"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00072"})
SET m.premise_id = "PREM_00072", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_015"}), (m:SmartMeter {meter_id: "SM_00072"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00073"})
SET m.premise_id = "PREM_00073", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_015"}), (m:SmartMeter {meter_id: "SM_00073"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00074"})
SET m.premise_id = "PREM_00074", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_015"}), (m:SmartMeter {meter_id: "SM_00074"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00075"})
SET m.premise_id = "PREM_00075", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_015"}), (m:SmartMeter {meter_id: "SM_00075"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_016"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_004"}), (t:Transformer {asset_id: "TX_016"})
MERGE (f)-[:CONNECTS_TO {distance_m: 280}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00076"})
SET m.premise_id = "PREM_00076", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_016"}), (m:SmartMeter {meter_id: "SM_00076"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00077"})
SET m.premise_id = "PREM_00077", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_016"}), (m:SmartMeter {meter_id: "SM_00077"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00078"})
SET m.premise_id = "PREM_00078", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_016"}), (m:SmartMeter {meter_id: "SM_00078"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00079"})
SET m.premise_id = "PREM_00079", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_016"}), (m:SmartMeter {meter_id: "SM_00079"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00080"})
SET m.premise_id = "PREM_00080", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_016"}), (m:SmartMeter {meter_id: "SM_00080"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_005"})
SET s.name = "Substation 5", s.voltage_kv = 11, s.region = "Region 2";

MERGE (f:Feeder {feeder_id: "F_005"})
SET f.name = "Feeder 5", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_005"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 3.5}]->(s);

MATCH (s:Substation {substation_id: "SS_005"}), (f:Feeder {feeder_id: "F_005"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1000}]->(f);

MERGE (t:Transformer {asset_id: "TX_017"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_005"}), (t:Transformer {asset_id: "TX_017"})
MERGE (f)-[:CONNECTS_TO {distance_m: 285}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00081"})
SET m.premise_id = "PREM_00081", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_017"}), (m:SmartMeter {meter_id: "SM_00081"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00082"})
SET m.premise_id = "PREM_00082", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_017"}), (m:SmartMeter {meter_id: "SM_00082"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00083"})
SET m.premise_id = "PREM_00083", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_017"}), (m:SmartMeter {meter_id: "SM_00083"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00084"})
SET m.premise_id = "PREM_00084", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_017"}), (m:SmartMeter {meter_id: "SM_00084"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00085"})
SET m.premise_id = "PREM_00085", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_017"}), (m:SmartMeter {meter_id: "SM_00085"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_018"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_005"}), (t:Transformer {asset_id: "TX_018"})
MERGE (f)-[:CONNECTS_TO {distance_m: 290}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00086"})
SET m.premise_id = "PREM_00086", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_018"}), (m:SmartMeter {meter_id: "SM_00086"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00087"})
SET m.premise_id = "PREM_00087", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_018"}), (m:SmartMeter {meter_id: "SM_00087"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00088"})
SET m.premise_id = "PREM_00088", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_018"}), (m:SmartMeter {meter_id: "SM_00088"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00089"})
SET m.premise_id = "PREM_00089", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_018"}), (m:SmartMeter {meter_id: "SM_00089"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00090"})
SET m.premise_id = "PREM_00090", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_018"}), (m:SmartMeter {meter_id: "SM_00090"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_019"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_005"}), (t:Transformer {asset_id: "TX_019"})
MERGE (f)-[:CONNECTS_TO {distance_m: 295}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00091"})
SET m.premise_id = "PREM_00091", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_019"}), (m:SmartMeter {meter_id: "SM_00091"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00092"})
SET m.premise_id = "PREM_00092", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_019"}), (m:SmartMeter {meter_id: "SM_00092"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00093"})
SET m.premise_id = "PREM_00093", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_019"}), (m:SmartMeter {meter_id: "SM_00093"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00094"})
SET m.premise_id = "PREM_00094", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_019"}), (m:SmartMeter {meter_id: "SM_00094"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00095"})
SET m.premise_id = "PREM_00095", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_019"}), (m:SmartMeter {meter_id: "SM_00095"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_020"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_005"}), (t:Transformer {asset_id: "TX_020"})
MERGE (f)-[:CONNECTS_TO {distance_m: 300}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00096"})
SET m.premise_id = "PREM_00096", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_020"}), (m:SmartMeter {meter_id: "SM_00096"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00097"})
SET m.premise_id = "PREM_00097", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_020"}), (m:SmartMeter {meter_id: "SM_00097"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00098"})
SET m.premise_id = "PREM_00098", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_020"}), (m:SmartMeter {meter_id: "SM_00098"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00099"})
SET m.premise_id = "PREM_00099", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_020"}), (m:SmartMeter {meter_id: "SM_00099"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00100"})
SET m.premise_id = "PREM_00100", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_020"}), (m:SmartMeter {meter_id: "SM_00100"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_006"})
SET s.name = "Substation 6", s.voltage_kv = 11, s.region = "Region 3";

MERGE (f:Feeder {feeder_id: "F_006"})
SET f.name = "Feeder 6", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_006"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 3.9}]->(s);

MATCH (s:Substation {substation_id: "SS_006"}), (f:Feeder {feeder_id: "F_006"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1020}]->(f);

MERGE (t:Transformer {asset_id: "TX_021"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_006"}), (t:Transformer {asset_id: "TX_021"})
MERGE (f)-[:CONNECTS_TO {distance_m: 305}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00101"})
SET m.premise_id = "PREM_00101", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_021"}), (m:SmartMeter {meter_id: "SM_00101"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00102"})
SET m.premise_id = "PREM_00102", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_021"}), (m:SmartMeter {meter_id: "SM_00102"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00103"})
SET m.premise_id = "PREM_00103", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_021"}), (m:SmartMeter {meter_id: "SM_00103"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00104"})
SET m.premise_id = "PREM_00104", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_021"}), (m:SmartMeter {meter_id: "SM_00104"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00105"})
SET m.premise_id = "PREM_00105", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_021"}), (m:SmartMeter {meter_id: "SM_00105"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_022"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_006"}), (t:Transformer {asset_id: "TX_022"})
MERGE (f)-[:CONNECTS_TO {distance_m: 310}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00106"})
SET m.premise_id = "PREM_00106", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_022"}), (m:SmartMeter {meter_id: "SM_00106"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00107"})
SET m.premise_id = "PREM_00107", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_022"}), (m:SmartMeter {meter_id: "SM_00107"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00108"})
SET m.premise_id = "PREM_00108", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_022"}), (m:SmartMeter {meter_id: "SM_00108"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00109"})
SET m.premise_id = "PREM_00109", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_022"}), (m:SmartMeter {meter_id: "SM_00109"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00110"})
SET m.premise_id = "PREM_00110", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_022"}), (m:SmartMeter {meter_id: "SM_00110"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_023"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_006"}), (t:Transformer {asset_id: "TX_023"})
MERGE (f)-[:CONNECTS_TO {distance_m: 315}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00111"})
SET m.premise_id = "PREM_00111", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_023"}), (m:SmartMeter {meter_id: "SM_00111"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00112"})
SET m.premise_id = "PREM_00112", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_023"}), (m:SmartMeter {meter_id: "SM_00112"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00113"})
SET m.premise_id = "PREM_00113", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_023"}), (m:SmartMeter {meter_id: "SM_00113"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00114"})
SET m.premise_id = "PREM_00114", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_023"}), (m:SmartMeter {meter_id: "SM_00114"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00115"})
SET m.premise_id = "PREM_00115", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_023"}), (m:SmartMeter {meter_id: "SM_00115"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_024"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_006"}), (t:Transformer {asset_id: "TX_024"})
MERGE (f)-[:CONNECTS_TO {distance_m: 320}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00116"})
SET m.premise_id = "PREM_00116", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_024"}), (m:SmartMeter {meter_id: "SM_00116"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00117"})
SET m.premise_id = "PREM_00117", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_024"}), (m:SmartMeter {meter_id: "SM_00117"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00118"})
SET m.premise_id = "PREM_00118", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_024"}), (m:SmartMeter {meter_id: "SM_00118"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00119"})
SET m.premise_id = "PREM_00119", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_024"}), (m:SmartMeter {meter_id: "SM_00119"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00120"})
SET m.premise_id = "PREM_00120", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_024"}), (m:SmartMeter {meter_id: "SM_00120"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_007"})
SET s.name = "Substation 7", s.voltage_kv = 11, s.region = "Region 1";

MERGE (f:Feeder {feeder_id: "F_007"})
SET f.name = "Feeder 7", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_007"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 4.3}]->(s);

MATCH (s:Substation {substation_id: "SS_007"}), (f:Feeder {feeder_id: "F_007"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1040}]->(f);

MERGE (t:Transformer {asset_id: "TX_025"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_007"}), (t:Transformer {asset_id: "TX_025"})
MERGE (f)-[:CONNECTS_TO {distance_m: 325}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00121"})
SET m.premise_id = "PREM_00121", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_025"}), (m:SmartMeter {meter_id: "SM_00121"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00122"})
SET m.premise_id = "PREM_00122", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_025"}), (m:SmartMeter {meter_id: "SM_00122"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00123"})
SET m.premise_id = "PREM_00123", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_025"}), (m:SmartMeter {meter_id: "SM_00123"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00124"})
SET m.premise_id = "PREM_00124", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_025"}), (m:SmartMeter {meter_id: "SM_00124"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00125"})
SET m.premise_id = "PREM_00125", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_025"}), (m:SmartMeter {meter_id: "SM_00125"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_026"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_007"}), (t:Transformer {asset_id: "TX_026"})
MERGE (f)-[:CONNECTS_TO {distance_m: 330}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00126"})
SET m.premise_id = "PREM_00126", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_026"}), (m:SmartMeter {meter_id: "SM_00126"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00127"})
SET m.premise_id = "PREM_00127", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_026"}), (m:SmartMeter {meter_id: "SM_00127"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00128"})
SET m.premise_id = "PREM_00128", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_026"}), (m:SmartMeter {meter_id: "SM_00128"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00129"})
SET m.premise_id = "PREM_00129", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_026"}), (m:SmartMeter {meter_id: "SM_00129"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00130"})
SET m.premise_id = "PREM_00130", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_026"}), (m:SmartMeter {meter_id: "SM_00130"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_027"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_007"}), (t:Transformer {asset_id: "TX_027"})
MERGE (f)-[:CONNECTS_TO {distance_m: 335}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00131"})
SET m.premise_id = "PREM_00131", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_027"}), (m:SmartMeter {meter_id: "SM_00131"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00132"})
SET m.premise_id = "PREM_00132", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_027"}), (m:SmartMeter {meter_id: "SM_00132"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00133"})
SET m.premise_id = "PREM_00133", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_027"}), (m:SmartMeter {meter_id: "SM_00133"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00134"})
SET m.premise_id = "PREM_00134", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_027"}), (m:SmartMeter {meter_id: "SM_00134"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00135"})
SET m.premise_id = "PREM_00135", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_027"}), (m:SmartMeter {meter_id: "SM_00135"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_028"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_007"}), (t:Transformer {asset_id: "TX_028"})
MERGE (f)-[:CONNECTS_TO {distance_m: 340}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00136"})
SET m.premise_id = "PREM_00136", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_028"}), (m:SmartMeter {meter_id: "SM_00136"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00137"})
SET m.premise_id = "PREM_00137", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_028"}), (m:SmartMeter {meter_id: "SM_00137"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00138"})
SET m.premise_id = "PREM_00138", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_028"}), (m:SmartMeter {meter_id: "SM_00138"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00139"})
SET m.premise_id = "PREM_00139", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_028"}), (m:SmartMeter {meter_id: "SM_00139"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00140"})
SET m.premise_id = "PREM_00140", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_028"}), (m:SmartMeter {meter_id: "SM_00140"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_008"})
SET s.name = "Substation 8", s.voltage_kv = 11, s.region = "Region 2";

MERGE (f:Feeder {feeder_id: "F_008"})
SET f.name = "Feeder 8", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_008"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 4.7}]->(s);

MATCH (s:Substation {substation_id: "SS_008"}), (f:Feeder {feeder_id: "F_008"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1060}]->(f);

MERGE (t:Transformer {asset_id: "TX_029"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_008"}), (t:Transformer {asset_id: "TX_029"})
MERGE (f)-[:CONNECTS_TO {distance_m: 345}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00141"})
SET m.premise_id = "PREM_00141", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_029"}), (m:SmartMeter {meter_id: "SM_00141"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00142"})
SET m.premise_id = "PREM_00142", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_029"}), (m:SmartMeter {meter_id: "SM_00142"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00143"})
SET m.premise_id = "PREM_00143", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_029"}), (m:SmartMeter {meter_id: "SM_00143"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00144"})
SET m.premise_id = "PREM_00144", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_029"}), (m:SmartMeter {meter_id: "SM_00144"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00145"})
SET m.premise_id = "PREM_00145", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_029"}), (m:SmartMeter {meter_id: "SM_00145"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_030"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_008"}), (t:Transformer {asset_id: "TX_030"})
MERGE (f)-[:CONNECTS_TO {distance_m: 350}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00146"})
SET m.premise_id = "PREM_00146", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_030"}), (m:SmartMeter {meter_id: "SM_00146"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00147"})
SET m.premise_id = "PREM_00147", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_030"}), (m:SmartMeter {meter_id: "SM_00147"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00148"})
SET m.premise_id = "PREM_00148", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_030"}), (m:SmartMeter {meter_id: "SM_00148"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00149"})
SET m.premise_id = "PREM_00149", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_030"}), (m:SmartMeter {meter_id: "SM_00149"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00150"})
SET m.premise_id = "PREM_00150", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_030"}), (m:SmartMeter {meter_id: "SM_00150"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_031"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_008"}), (t:Transformer {asset_id: "TX_031"})
MERGE (f)-[:CONNECTS_TO {distance_m: 355}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00151"})
SET m.premise_id = "PREM_00151", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_031"}), (m:SmartMeter {meter_id: "SM_00151"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00152"})
SET m.premise_id = "PREM_00152", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_031"}), (m:SmartMeter {meter_id: "SM_00152"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00153"})
SET m.premise_id = "PREM_00153", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_031"}), (m:SmartMeter {meter_id: "SM_00153"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00154"})
SET m.premise_id = "PREM_00154", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_031"}), (m:SmartMeter {meter_id: "SM_00154"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00155"})
SET m.premise_id = "PREM_00155", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_031"}), (m:SmartMeter {meter_id: "SM_00155"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_032"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_008"}), (t:Transformer {asset_id: "TX_032"})
MERGE (f)-[:CONNECTS_TO {distance_m: 360}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00156"})
SET m.premise_id = "PREM_00156", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_032"}), (m:SmartMeter {meter_id: "SM_00156"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00157"})
SET m.premise_id = "PREM_00157", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_032"}), (m:SmartMeter {meter_id: "SM_00157"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00158"})
SET m.premise_id = "PREM_00158", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_032"}), (m:SmartMeter {meter_id: "SM_00158"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00159"})
SET m.premise_id = "PREM_00159", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_032"}), (m:SmartMeter {meter_id: "SM_00159"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00160"})
SET m.premise_id = "PREM_00160", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_032"}), (m:SmartMeter {meter_id: "SM_00160"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_009"})
SET s.name = "Substation 9", s.voltage_kv = 11, s.region = "Region 3";

MERGE (f:Feeder {feeder_id: "F_009"})
SET f.name = "Feeder 9", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_009"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 5.1}]->(s);

MATCH (s:Substation {substation_id: "SS_009"}), (f:Feeder {feeder_id: "F_009"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1080}]->(f);

MERGE (t:Transformer {asset_id: "TX_033"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_009"}), (t:Transformer {asset_id: "TX_033"})
MERGE (f)-[:CONNECTS_TO {distance_m: 365}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00161"})
SET m.premise_id = "PREM_00161", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_033"}), (m:SmartMeter {meter_id: "SM_00161"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00162"})
SET m.premise_id = "PREM_00162", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_033"}), (m:SmartMeter {meter_id: "SM_00162"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00163"})
SET m.premise_id = "PREM_00163", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_033"}), (m:SmartMeter {meter_id: "SM_00163"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00164"})
SET m.premise_id = "PREM_00164", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_033"}), (m:SmartMeter {meter_id: "SM_00164"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00165"})
SET m.premise_id = "PREM_00165", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_033"}), (m:SmartMeter {meter_id: "SM_00165"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_034"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_009"}), (t:Transformer {asset_id: "TX_034"})
MERGE (f)-[:CONNECTS_TO {distance_m: 370}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00166"})
SET m.premise_id = "PREM_00166", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_034"}), (m:SmartMeter {meter_id: "SM_00166"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00167"})
SET m.premise_id = "PREM_00167", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_034"}), (m:SmartMeter {meter_id: "SM_00167"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00168"})
SET m.premise_id = "PREM_00168", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_034"}), (m:SmartMeter {meter_id: "SM_00168"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00169"})
SET m.premise_id = "PREM_00169", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_034"}), (m:SmartMeter {meter_id: "SM_00169"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00170"})
SET m.premise_id = "PREM_00170", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_034"}), (m:SmartMeter {meter_id: "SM_00170"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_035"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_009"}), (t:Transformer {asset_id: "TX_035"})
MERGE (f)-[:CONNECTS_TO {distance_m: 375}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00171"})
SET m.premise_id = "PREM_00171", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_035"}), (m:SmartMeter {meter_id: "SM_00171"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00172"})
SET m.premise_id = "PREM_00172", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_035"}), (m:SmartMeter {meter_id: "SM_00172"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00173"})
SET m.premise_id = "PREM_00173", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_035"}), (m:SmartMeter {meter_id: "SM_00173"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00174"})
SET m.premise_id = "PREM_00174", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_035"}), (m:SmartMeter {meter_id: "SM_00174"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00175"})
SET m.premise_id = "PREM_00175", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_035"}), (m:SmartMeter {meter_id: "SM_00175"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_036"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_009"}), (t:Transformer {asset_id: "TX_036"})
MERGE (f)-[:CONNECTS_TO {distance_m: 380}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00176"})
SET m.premise_id = "PREM_00176", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_036"}), (m:SmartMeter {meter_id: "SM_00176"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00177"})
SET m.premise_id = "PREM_00177", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_036"}), (m:SmartMeter {meter_id: "SM_00177"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00178"})
SET m.premise_id = "PREM_00178", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_036"}), (m:SmartMeter {meter_id: "SM_00178"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00179"})
SET m.premise_id = "PREM_00179", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_036"}), (m:SmartMeter {meter_id: "SM_00179"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00180"})
SET m.premise_id = "PREM_00180", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_036"}), (m:SmartMeter {meter_id: "SM_00180"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (s:Substation {substation_id: "SS_010"})
SET s.name = "Substation 10", s.voltage_kv = 11, s.region = "Region 1";

MERGE (f:Feeder {feeder_id: "F_010"})
SET f.name = "Feeder 10", f.status = "active";

MATCH (g:GridSupplyPoint {gsp_id: "GSP_NORTH"}), (s:Substation {substation_id: "SS_010"})
MERGE (g)-[:FEEDS {voltage_kv: 132, length_km: 5.5}]->(s);

MATCH (s:Substation {substation_id: "SS_010"}), (f:Feeder {feeder_id: "F_010"})
MERGE (s)-[:SUPPLIES {capacity_kva: 2000, current_load_kva: 1100}]->(f);

MERGE (t:Transformer {asset_id: "TX_037"})
SET t.rating_kva = 400, t.status = "normal", t.manufacturer = "Siemens";

MATCH (f:Feeder {feeder_id: "F_010"}), (t:Transformer {asset_id: "TX_037"})
MERGE (f)-[:CONNECTS_TO {distance_m: 385}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00181"})
SET m.premise_id = "PREM_00181", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_037"}), (m:SmartMeter {meter_id: "SM_00181"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00182"})
SET m.premise_id = "PREM_00182", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_037"}), (m:SmartMeter {meter_id: "SM_00182"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00183"})
SET m.premise_id = "PREM_00183", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_037"}), (m:SmartMeter {meter_id: "SM_00183"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00184"})
SET m.premise_id = "PREM_00184", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_037"}), (m:SmartMeter {meter_id: "SM_00184"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00185"})
SET m.premise_id = "PREM_00185", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_037"}), (m:SmartMeter {meter_id: "SM_00185"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_038"})
SET t.rating_kva = 550, t.status = "normal", t.manufacturer = "Schneider";

MATCH (f:Feeder {feeder_id: "F_010"}), (t:Transformer {asset_id: "TX_038"})
MERGE (f)-[:CONNECTS_TO {distance_m: 390}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00186"})
SET m.premise_id = "PREM_00186", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_038"}), (m:SmartMeter {meter_id: "SM_00186"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00187"})
SET m.premise_id = "PREM_00187", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_038"}), (m:SmartMeter {meter_id: "SM_00187"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00188"})
SET m.premise_id = "PREM_00188", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_038"}), (m:SmartMeter {meter_id: "SM_00188"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00189"})
SET m.premise_id = "PREM_00189", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_038"}), (m:SmartMeter {meter_id: "SM_00189"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00190"})
SET m.premise_id = "PREM_00190", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_038"}), (m:SmartMeter {meter_id: "SM_00190"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_039"})
SET t.rating_kva = 700, t.status = "normal", t.manufacturer = "GE";

MATCH (f:Feeder {feeder_id: "F_010"}), (t:Transformer {asset_id: "TX_039"})
MERGE (f)-[:CONNECTS_TO {distance_m: 395}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00191"})
SET m.premise_id = "PREM_00191", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_039"}), (m:SmartMeter {meter_id: "SM_00191"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00192"})
SET m.premise_id = "PREM_00192", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_039"}), (m:SmartMeter {meter_id: "SM_00192"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00193"})
SET m.premise_id = "PREM_00193", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_039"}), (m:SmartMeter {meter_id: "SM_00193"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00194"})
SET m.premise_id = "PREM_00194", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_039"}), (m:SmartMeter {meter_id: "SM_00194"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00195"})
SET m.premise_id = "PREM_00195", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_039"}), (m:SmartMeter {meter_id: "SM_00195"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (t:Transformer {asset_id: "TX_040"})
SET t.rating_kva = 250, t.status = "normal", t.manufacturer = "ABB";

MATCH (f:Feeder {feeder_id: "F_010"}), (t:Transformer {asset_id: "TX_040"})
MERGE (f)-[:CONNECTS_TO {distance_m: 400}]->(t);

MERGE (m:SmartMeter {meter_id: "SM_00196"})
SET m.premise_id = "PREM_00196", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_040"}), (m:SmartMeter {meter_id: "SM_00196"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00197"})
SET m.premise_id = "PREM_00197", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_040"}), (m:SmartMeter {meter_id: "SM_00197"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00198"})
SET m.premise_id = "PREM_00198", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_040"}), (m:SmartMeter {meter_id: "SM_00198"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00199"})
SET m.premise_id = "PREM_00199", m.tariff_class = "residential";

MATCH (t:Transformer {asset_id: "TX_040"}), (m:SmartMeter {meter_id: "SM_00199"})
MERGE (t)-[:CONNECTS_TO]->(m);

MERGE (m:SmartMeter {meter_id: "SM_00200"})
SET m.premise_id = "PREM_00200", m.tariff_class = "commercial";

MATCH (t:Transformer {asset_id: "TX_040"}), (m:SmartMeter {meter_id: "SM_00200"})
MERGE (t)-[:CONNECTS_TO]->(m);

// Sample traversal queries
// MATCH (s:Substation {substation_id:"SS_001"})-[:SUPPLIES|CONNECTS_TO*1..4]->(n) RETURN labels(n), n LIMIT 50;
// MATCH (m:SmartMeter {meter_id:"SM_00001"})<-[:CONNECTS_TO]-(t:Transformer)-[:CONNECTS_TO]->(peer:SmartMeter) RETURN peer.meter_id, peer.premise_id;
