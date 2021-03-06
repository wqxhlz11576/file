ngx.header.content_type="application/json;charset=utf8"
local cjson = require("cjson")
local mysql = require("resty.mysql")
local uri_args = ngx.req.get_uri_args()
local position = uri_args["position"]

local db = mysql:new()
db:set_timeout(1000)  
local props = {  
    host = "35.193.67.118",  
    port = 33306,  
    database = "changgou_business",  
    user = "root",  
    password = "123456"  
}  

local res = db:connect(props)  
local select_sql = "select url,image from tb_ad where status ='1' and position='"..position.."' and start_time<= NOW() AND end_time>= NOW()"  
res = db:query(select_sql)  
db:close()  

local redis = require("resty.redis")
local red = redis:new()
red:set_timeout(2000)

local ip ="35.193.67.118"
local port = 6379
red:connect(ip,port)

red:set("ad_"..position,cjson.encode(res))
red:close()

ngx.say("{\"flag\":true,\"position\":\""..position.."\"}")

