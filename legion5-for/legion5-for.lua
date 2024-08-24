  local lg5 = {
    version = "day 2",
    screen_w = 960,
    screen_h = 720,
    scene = 0,

    lmap = {},
    id_ship = -1,--rsave_numb(0)
    pos_ship_map = {x=0,y=0},
    map_cursor={x=10,y=10,w=16,h=16}
  }
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
function _PortalIdToSpr(id)
  if id==25 then
    return 16 
  elseif id==24 then
    return 18
  elseif id==3 then
    return 21
  elseif id==5 then
    return 24
  elseif id==31 then
    return 27
  end
  return 16
end
function _MapDraw(lg5,px,py)
  for y=0, lg5.lmap.h do
    for x=0, lg5.lmap.w do
      local v = _MapGet(lg5,x,y)
      if v==-1 then
        rectb(px+x*lg5.lmap.tile,py+y*lg5.lmap.tile,lg5.lmap.tile,lg5.lmap.tile,1)
      else
        rectb(px+x*lg5.lmap.tile,py+y*lg5.lmap.tile,lg5.lmap.tile,lg5.lmap.tile,1)
        spr(_PortalIdToSpr(v),
          px+x*lg5.lmap.tile+8*2,
          py+y*lg5.lmap.tile+8*2,2,0)
        --rect(7+px+x*lg5.lmap.tile,7+py+y*lg5.lmap.tile,lg5.lmap.tile-14,lg5.lmap.tile-14,v)
      end
    end
  end
  
  spr(lg5.id_ship*3,16+px+lg5.pos_ship_map.x*lg5.lmap.tile,16+py+lg5.pos_ship_map.y*lg5.lmap.tile,2,0)
end
function _GetSignalId(tag)
  local ri = -1
  if tag=="tutorial" then
    ri=25
  elseif tag=="low" then
    ri=24
  elseif tag=="midd" then
    ri=3
  elseif tag=="hight" then
    ri=5
  elseif tag=="nightmare" then
    ri=31
  end
  return ri
end
function _SignalIdToTag(id)
  if id==25 then
    return "tutorial"  
  elseif id==24 then
    return "low"
  elseif id==3 then
    return "midd"
  elseif id==5 then
    return "hight"
  elseif id==31 then
    return "nightmare"
  end
  return "unknow"
end

function _MapSetsignal(lg5,x,y,tag)
  local sid = _GetSignalId(tag)
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
  lg5.pos_ship_map.x = rdmx
  lg5.pos_ship_map.y = rdmy
end
function _Rdm_Signal_Pos(lg5,tag,distmin,distmax)
  local rdmx=0
  local rdmy=0
  local lid=0
  local cdist=0
  rdmx = math.random(0,lg5.lmap.w-6)
  rdmy = math.random(0,lg5.lmap.h)
  lid = _MapGet(lg5,rdmx,rdmy)
  cdist = math.abs(rdmx-lg5.pos_ship_map.x)+math.abs(rdmy-lg5.pos_ship_map.y)
  if lid==-1 and cdist>=distmin and cdist<distmax then
    _MapSetsignal(lg5,rdmx,rdmy,tag)
  else
    _Rdm_Signal_Pos(lg5,tag,distmin,distmax)
    return 0
  end
end

function lg5:scene_title()
  -- code run 60/seconds
  cls(19)
  text("Legion5 : fox on the run",(lg5.screen_w/2)-260,30+(lg5.screen_h/4),1,45)
  text("press up",(lg5.screen_w/2)-45,500,1,25)

  spr(lg5.id_ship*3,(lg5.screen_w/2),330,8,0)

  text("powered by egba engine",730,690,1,18)
  text("ver "..lg5.version.." by magnus oblerion",20,690,1,18)

  if btnp(2) then
    if lg5.id_ship == 0 then
      lg5.id_ship=2
    else
      lg5.id_ship = lg5.id_ship-1
    end
  end
  if btnp(3) then
    if self.id_ship == 2 then
      self.id_ship=0
    else
      self.id_ship = self.id_ship+1
    end
  end

  if	btnp(0) then
    wsave_numb(0,self.id_ship)
    self.scene=1
  end 
end

-- signal choose
function lg5:scene_bigmap()
  cls(19)
  text("map system",200,30,1,20)
  _Gui_Map(lg5,450,50,15,20)
  local sid = _MapGet(lg5,lg5.map_cursor.x,lg5.map_cursor.y)
  local scord = string.format("X %x | Y %x",lg5.map_cursor.x,lg5.map_cursor.y)
  if sid==-1 then
    _Gui_Signal("none","none",scord)
  else
    _Gui_Signal("unknow",_SignalIdToTag(sid),scord)
  end
end

function lg5:scene_game()

end

lg5.id_ship=rsave_numb(0)
_MapInit(lg5,15,20)
_Rdm_Player_Pos(lg5)
_Rdm_Signal_Pos(lg5,"low",10,13)
_Rdm_Signal_Pos(lg5,"tutorial",4,6)
_Rdm_Signal_Pos(lg5,"midd",15,16)
_Rdm_Signal_Pos(lg5,"hight",17,19)
function EGBA()
  if lg5.scene==0 then
    lg5:scene_title()
  elseif lg5.scene==1 then
    lg5:scene_bigmap()
  elseif _lg5.scene==2 then
    lg5:scene_game()
  end
end
