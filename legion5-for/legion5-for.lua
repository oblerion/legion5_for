  local lg5 = {
    version     = "day 3",
    screen_w    = 960,
    screen_h    = 720,
    scene       = 0,

    map_cursor  = {
      x=10,
      y=10,
      w=16,
      h=16
    },
    lmap        = {},
    lbullets    = {},
    lenemies    = {},
    
    camera={x=0,y=0},
    
    bullet_spr={
      Etype1    = 48,
      Etype2    = 49,
      Etype3    = 50,
      Etype4    = 51,
      Etype5    = 52,
      ship1     = 53,
      ship2     = 54,
      ship3     = 55
    },
    
    ship_id     = -1,--rsave_numb(0)
    ship_pos    = {x=0,y=0},
    ship_rot    = 0,
    
    ships_spr={
      fox1      = 0,
      fox2      = 1,
      fox3      = 2,
      flow1     = 3,
      flow2     = 4,
      flow3     = 5,
      spic1     = 6,
      spic2     = 7,
      spic3     = 8
    },
    
    enemies_spr={
      tuto1     = 17,
      low1      = 19,
      low2      = 20,
      midd1     = 21,
      midd2     = 22,
      hight1    = 24,
      hight2    = 25,
      nightm1   = 27,
      nightm2   = 28
    },
    
    portals_spr={
      tutorial  = 16,
      low       = 18,
      midd      = 21,
      hight     = 24,
      nightmare = 27
    },
    
    portals_id={
      tutorial  = 25,
      low       = 24,
      midd      = 3,
      hight     = 5,
      nightmare = 31
    },
    
    powup_spr={
      upgrade   = 32,
      heal      = 33,
      datajump  = 34,
      ammo      = 35
    }
  }
function _PlayerMove(lg5,px,py)
  lg5.ship_pos.x = lg5.ship_pos.x + px
  lg5.ship_pos.y = lg5.ship_pos.y + py
end
function _PlayerRot(lg5,rot)
  lg5.ship_rot=rot
end
function _MapInit(lg5,pw,ph)
  lg5.lmap = {w=pw,h=ph,l={},tile=30}
  for y=0,ph do
    for x=0,pw do
      lg5.lmap.l[y*pw+x]=-1
    end
  end
end
function _MapSet(lg5,x,y,v)
  lg5.lmap.l[y*lg5.lmap.w+x]=v
end
function _MapGet(lg5,x,y)
  return lg5.lmap.l[y*lg5.lmap.w+x]
end
function _PortalIdToSpr(lg5,id)
  if id==lg5.portals_id.tutorial then
    return lg5.portals_spr.tutorial 
  elseif id==lg5.portals_id.low then
    return lg5.portals_spr.low
  elseif id==lg5.portals_id.midd then
    return lg5.portals_spr.midd
  elseif id==lg5.portals_id.hight then
    return lg5.portals_spr.hight
  elseif id==lg5.portals_id.nightmare then
    return lg5.portlals_spr.nightmare
  end
  return 16
end
function _MapDraw(lg5,px,py,isgrid,scale)
  local lisgrid = true
  local lscale = 2
  if scale~=nil then
    lscale = scale
  end
  if isgrid==false then
    lisgrid=false
  end
  lg5.lmap.tile = 16*lscale
  for y=0, lg5.lmap.h do
    for x=0, lg5.lmap.w do
      local v = _MapGet(lg5,x,y)
      if v==-1 then
        if lisgrid==true then 
          rectb(px+x*lg5.lmap.tile,py+y*lg5.lmap.tile,lg5.lmap.tile,lg5.lmap.tile,1) 
        end
      else
        if lisgrid==true then 
          rectb(px+x*lg5.lmap.tile,py+y*lg5.lmap.tile,lg5.lmap.tile,lg5.lmap.tile,1) 
        end
        spr(_PortalIdToSpr(lg5,v),
          px+x*lg5.lmap.tile+8*lscale,
          py+y*lg5.lmap.tile+8*lscale,lscale,0)
        --rect(7+px+x*lg5.lmap.tile,7+py+y*lg5.lmap.tile,lg5.lmap.tile-14,lg5.lmap.tile-14,v)
      end
    end
  end
end
function _MapDrawPlayer(lg5,px,py,scale,rot)
  local lrot = 0
  local lscale = 2
  if scale~=nil then
    lscale = scale
  end
  if rot~=nil then
    lrot = rot
  end
  spr(lg5.ship_id*3,
    px+lg5.ship_pos.x*lg5.lmap.tile+8*lscale,
    py+lg5.ship_pos.y*lg5.lmap.tile+8*lscale,lscale,lrot)
end
function _GetSignalId(lg5,tag)
  local ri = -1
  if tag=="tutorial" then
    ri=lg5.portals_id.tutorial
  elseif tag=="low" then
    ri=lg5.portals_id.low
  elseif tag=="midd" then
    ri=lg5.portals_id.midd
  elseif tag=="hight" then
    ri=lg5.portals_id.hight
  elseif tag=="nightmare" then
    ri=lg5.portals_id.nightmare
  end
  return ri
end
function _SignalIdToTag(lg5,id)
  if id==lg5.portals_id.tutorial then
    return "tutorial"  
  elseif id==lg5.portals_id.low then
    return "low"
  elseif id==lg5.portals_id.midd then
    return "midd"
  elseif id==lg5.portals_id.hight then
    return "hight"
  elseif id==lg5.portals_id.nightmare then
    return "nightmare"
  end
  return "unknow"
end

function _MapSetsignal(lg5,x,y,tag)
  local sid = _GetSignalId(lg5,tag)
  _MapSet(lg5,x,y,sid)
end
function _MapGetsignal(lg5,x,y)
  local sid = _MapGet(lg5,x,y)
  return _SignalIdToTag(sid)
end
local gtime=0.0;
function _SignalS_Draw(px,py,t,speed,yw,pcol)
  local h=gtime*speed --x speed
  --local t= 1/6--1.2 -- time
  --local yw = 30 -- y size
  for lx=0,35 do
    local llx =px+lx*10+math.cos(lx+h)*0.5
    local lly =py + (yw/2) +(yw*math.sin((2*math.pi*t*(lx+h))))
    rect(llx,lly,4,4,pcol)
  end
  gtime = gtime+deltatime()
end
function _Gui_Signal(ptype,pstreng,pcord)
  text("-- signal --" ,50,100,1,25)
  text("type   : "..ptype ,50,130,1,25)
  text("strg   : "..(pstreng or "unknow"),50,160,1,25)
  text("cord   : "..pcord,50,190,1,25)
  if pstreng=="tutorial" then
    _SignalS_Draw(45,245,1/3,12,8,25)
  elseif pstreng=="low" then
    _SignalS_Draw(45,245,1/4,12,10,24)
  elseif pstreng=="midd" then
    _SignalS_Draw(45,245,1/8,12,25,3)
  elseif pstreng=="hight" then
    _SignalS_Draw(45,245,1/10,13,45,5)
  elseif pstreng=="nightmare" then
    _SignalS_Draw(45,245,1/10,14,47,32)
    _SignalS_Draw(45,245,1/9,11,45,31)
    _SignalS_Draw(45,245,1/10,14,44,29)
  end
  rectb(40,90,364,300,1)
end
function _Gui_Map(lg5,px,py,pw,ph)
  rectb(px,py,pw*lg5.lmap.tile,ph*lg5.lmap.tile,1)
  if btnp(0) and lg5.map_cursor.y > 0 then
    lg5.map_cursor.y = lg5.map_cursor.y-1
  end
  if btnp(1) and lg5.map_cursor.y < ph then
    lg5.map_cursor.y = lg5.map_cursor.y+1
  end
  if btnp(2) and lg5.map_cursor.x > 0 then
    lg5.map_cursor.x = lg5.map_cursor.x-1
  end
  if btnp(3) and lg5.map_cursor.x < pw then
    lg5.map_cursor.x = lg5.map_cursor.x+1
  end
  rectb(px+2+lg5.map_cursor.x*lg5.lmap.tile,
    py+2+lg5.map_cursor.y*lg5.lmap.tile,
    lg5.lmap.tile-4,lg5.lmap.tile-4,15)
  _MapDraw(lg5,px,py)
 -- return _MapGet(lg5,lg5.map_cursor.x,lg5.map_cursor.y)
end
  --  function lg5:_collide(x,y,w,h,x2,y2,w2,h2)
--    if x<x2+w2 and
--    y<y2+h2 and
--    x2<x+w and
--    y2<y+h then
--      return true
--    end
--    return false
--  end
function _Rdm_Player_Pos(lg5)
  local rdmx = math.random(0,lg5.lmap.w-6)
  local rdmy = math.random(0,lg5.lmap.h)
  lg5.ship_pos.x = rdmx
  lg5.ship_pos.y = rdmy
end
function _Rdm_Signal_Pos(lg5,tag,distmin,distmax)
  local rdmx=0
  local rdmy=0
  local lid=0
  local cdist=0
  rdmx = math.random(1,lg5.lmap.w-1)
  rdmy = math.random(1,lg5.lmap.h-1)
  lid = _MapGet(lg5,rdmx,rdmy)
  cdist = math.abs(rdmx-lg5.ship_pos.x)+math.abs(rdmy-lg5.ship_pos.y)
  if lid==-1 and cdist>=distmin and cdist<distmax then
    _MapSetsignal(lg5,rdmx,rdmy,tag)
  else
    _Rdm_Signal_Pos(lg5,tag,distmin,distmax)
    return 0
  end
end

function _NewEnemy(lg5,pid,px,py)
  local mapid = _MapGet(lg5,px,py)
  if mapid==-1 then
    local e = {id=pid,x=px,y=py,rot=0}
    table.insert(lg5.lenemies,e)
  end
end

function _EnnemyDraw(lg5,xmap,ymap,scalemap)
  for _,v in pairs(lg5.lenemies)do
    spr(v.id,xmap+v.x*lg5.lmap.tile+8*scalemap,ymap+v.y*lg5.lmap.tile+8*scalemap,scalemap,v.rot)
  end
end

function _CameraUpdate(lg5,lscale)
  lg5.camera.x=0-(lg5.ship_pos.x-5)*16*lscale
  lg5.camera.y=0-(lg5.ship_pos.y-4)*16*lscale
end

function _NewBullet(lg5,pid,px,py,prot)
  local mapid = _MapGet(lg5,px,py)
  if mapid==-1 then
    local b = {id=pid,x=px,y=py,rot=prot}
    table.insert(lg5.lbullets,b)
  end
end

function _BulletDraw(lg5,xmap,ymap,scalemap)
  for _,v in pairs(lg5.lenemies)do
    spr(v.id,xmap+v.x*lg5.lmap.tile+8*scalemap,ymap+v.y*lg5.lmap.tile+8*scalemap,scalemap,v.rot)
  end
end

function lg5:scene_title()
  -- code run 60/seconds
  cls(19)
  text("Legion5 : fox on the run",(lg5.screen_w/2)-260,30+(lg5.screen_h/4),1,45)
  text("press up",(lg5.screen_w/2)-45,500,1,25)

  spr(lg5.ship_id*3,(lg5.screen_w/2),330,8,0)

  text("powered by egba engine",730,690,1,18)
  text("ver "..lg5.version.." by magnus oblerion",20,690,1,18)

  if btnp(2) then
    if lg5.ship_id == 0 then
      lg5.ship_id=2
    else
      lg5.ship_id = lg5.ship_id-1
    end
  end
  if btnp(3) then
    if self.ship_id == 2 then
      self.ship_id=0
    else
      self.ship_id = self.ship_id+1
    end
  end

  if	btnp(0) then
    wsave_numb(0,self.ship_id)
    self.scene=1
  end 
end

-- signal choose
function lg5:scene_bigmap()
  cls(19)
  text("map system",200,30,1,20)
  _Gui_Map(lg5,440,40,15,20)
  _MapDrawPlayer(lg5,440,40)
  local sid = _MapGet(lg5,lg5.map_cursor.x,lg5.map_cursor.y)
  local scord = string.format("X %x | Y %x",lg5.map_cursor.x,lg5.map_cursor.y)
  if sid==-1 then
    _Gui_Signal("none","none",scord)
  else
    _Gui_Signal("unknow",_SignalIdToTag(lg5,sid),scord)
  end
  if btnp(4) then
    lg5.scene=2
  end
  text("press x",50,450,1,20)
end

function lg5:scene_game()
  local lscale = 5
  local lx = 1
  local ly = 1
  
  cls(19)
  --player move
  if btnp(0) then
    _PlayerMove(lg5,0,-1)
    _PlayerRot(lg5,0)
  end
  if btnp(1) then
    _PlayerMove(lg5,0,1)
    _PlayerRot(lg5,2)
  end
  if btnp(2) then
    _PlayerMove(lg5,-1,0)
    _PlayerRot(lg5,3)
  end
  if btnp(3) then
    _PlayerMove(lg5,1,0)
    _PlayerRot(lg5,1)
  end
  _CameraUpdate(lg5,lscale)
  _MapDraw(lg5,
    lx+lg5.camera.x,--(lg5.ship_pos.x*16*6),
    ly+lg5.camera.y,--(lg5.ship_pos.y*16*6),
    true,lscale)
  _EnnemyDraw(lg5,lx+lg5.camera.x,ly+lg5.camera.y,lscale)
  _MapDrawPlayer(lg5,lx+lg5.camera.x,ly+lg5.camera.y,lscale,lg5.ship_rot)
end

lg5.ship_id=rsave_numb(0)
_MapInit(lg5,15,20)
_Rdm_Player_Pos(lg5)
_Rdm_Signal_Pos(lg5,"low",10,13)
_Rdm_Signal_Pos(lg5,"tutorial",4,6)
_Rdm_Signal_Pos(lg5,"midd",15,16)
_Rdm_Signal_Pos(lg5,"hight",17,19)
--_NewEnemy(lg5,lg5.enemies_spr.tuto1,1,1)

function EGBA()
  if lg5.scene==0 then
    lg5:scene_title()
  elseif lg5.scene==1 then
    lg5:scene_bigmap()
  elseif lg5.scene==2 then
    lg5:scene_game()
  end
end
