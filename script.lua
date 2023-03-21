tail_0 = models.model.Body.tail0
tail_1 = models.model.Body.tail0.tail1
tail_2 = models.model.Body.tail0.tail1.tail2
hood = models.model.Body.Hood

ltuft1 = models.model.Head.LeftTufts.t1
ltuft2 = models.model.Head.LeftTufts.t2
rtuft1 = models.model.Head.RightTufts.t1
rtuft2 = models.model.Head.RightTufts.t2

ears = models.model.Head.Ears
lear = ears.Left
rear = ears.Right

lbrow = models.model.Head.LeftBrow
rbrow = models.model.Head.RightBrow
eyes = models.model.Head.Eyes
blush = models.model.Head.Blush
squint = models.model.Head.Squint
facePain = models.model.Head.Pain


Hat = models.model.Head.Hat;
Jacket = models.model.Body.Jacket
LP = models.model.LeftLeg.LeftPants
RP = models.model.RightLeg.RightPants
LS = models.model.LeftArm.LeftSleeve
RS = models.model.RightArm.RightSleeve

UVorigin = vectors.vec(1, 21)
UVcol = 7
UVrow = 7
UVres = 64

A = 3.0

function wag(a, t, o)
	return a * math.sin((t + o) * math.pi * 2)
end

tickTime = 0.0
tailTime = 0.0

-- Target values
learAngleT = 0
rearAngleT = 0
t1T = 37.5
t2T = 25.0
t3T = 10.0
tailAngleT = A
tailSpeedT = 1.0 / 6.0

learAngle = learAngleT
rearAngle = rearAngleT
t1 = t1T
t2 = t2T
t3 = t3T
tailAngle = tailAngleT
tailSpeed = tailSpeedT

blinkMin = 4.0
blinkMax = 8.0
blinkDur = 0.1

canBlink = true
wearingHat = false
twitchleft = false

currentLBrow = 0
currentRBrow = 0
currentLBrowR = 0
currentRBrowR = 0
currentEyes = 0
currentPain = 0

math.randomseed(client.getSystemTime())

blinkTime = math.random(blinkMin, blinkMax)

ts = 1.0
as = 1.0
tailRate = 8.0

health = 0
lhealth = 0

damageTimer = 0.0
damageReset = 0.3

twitchDur = 0.05
twitchTimer = -twitchDur
twitchMinReset = 30.0
twitchMaxReset = 120.0

surpriseSpeed = 1
fallSurpriseSpeed = 0.9
cartSurpriseSpeed = 0.35

hungerPain = 0.6
starvingPain = 1.0
starvingThreshold = 0.75
damagePain = 1.8

blushing = false
cute = false
brow = false
browSerious = false

nightVision = 0
blindness = false
levitating = false
fireproof = false
hero = false

dryRate = 1.0 / 60.0
rainRate = 1.0 / 10.0
waterRate = 1.0 / 0.1
dropRate = 2.0
dropCounter = 1

wetness = 0.0

facesPage = action_wheel:newPage('facesPage')

function pings.blushPing(isToggled)
	blushing = isToggled
end

function pings.cutePing(isToggled)
	cute = isToggled
end

function pings.browPing(isToggled)
	brow = isToggled
end

function pings.browSPing(isToggled)
	browSerious = isToggled
end

function pings.resetTwitchPing(time, l)
	twitchTimer = time
	twitchleft = l
end

function pings.nightVisionPing(strength)
	eyes:setLight(strength)

	uv = eyes:getUV()
	if strength == 0 then
		uv.y = 0
	else
		uv.y = 2 / UVres
	end
	eyes:setUV(uv)

	nightVision = strength
end

function pings.blindPing(isToggled)
	blindness = isToggled
end

function pings.levitatingPing(isToggled)
	levitating = isToggled
end

function pings.fireproofPing(isToggled)
	fireproof = isToggled
end

function pings.heroPing(isToggled)
	hero = isToggled
end

modelTexture = textures:getTextures()[2]

action_wheel:setPage(facesPage)
blushAction = facesPage:newAction(1)
blushAction:setTexture(modelTexture, 0, 48, 16, 16, 1.5)
blushAction:onToggle(pings.blushPing)
blushAction:toggled(false)

cuteAction = facesPage:newAction(2)
cuteAction:setTexture(modelTexture, 16, 48, 16, 16, 1.5)
cuteAction:onToggle(pings.cutePing)
cuteAction:toggled(false)

browAction = facesPage:newAction(3)
browAction:setTexture(modelTexture, 32, 48, 16, 16, 1.5)
browAction:onToggle(pings.browPing)
browAction:toggled(false)

browSAction = facesPage:newAction(4)
browSAction:setTexture(modelTexture, 48, 48, 16, 16, 1.5)
browSAction:onToggle(pings.browSPing)
browSAction:toggled(false)


-- t: Controls interpolation from a to b
-- hl: Half life - Amount of t it takes from pass halfway from a to b
function erp(a, b, t, hl)
	x = math.clamp(1.0 / (2 ^ (t / hl)), 0, 1)
	return a * x + b * (1.0 - x)
end

function isVis(name)
	return player:isSkinLayerVisible(name)
end

function checkLayer(part, name)
	vis = part:getVisible() or false
	if vis ~= isVis(name) then
		part:visible(isVis(name))
	end
end

events.ENTITY_INIT:register(function()
	vanilla_model.INNER_LAYER:setVisible(false)
	vanilla_model.OUTER_LAYER:setVisible(false)
	lhealth = health
end)

events.TICK:register(function()
	back = player:getItem(5):getName()

	head = player:getItem(6):getName()

	wearingHat = head ~= 'Air'

	if back ~= "Air" and back ~= "Elytra" then
		if hood:getVisible() then
			hood:visible(false)
		end
	elseif hood:getVisible() ~= isVis("JACKET") then
		hood:visible(isVis("JACKET"))
	end

	checkLayer(LP, "LEFT_PANTS")
	checkLayer(RP, "RIGHT_PANTS")
	checkLayer(LS, "LEFT_SLEEVE")
	checkLayer(RS, "RIGHT_SLEEVE")
	checkLayer(Jacket, "JACKET")
	checkLayer(Hat, "HAT")
end)

events.WORLD_TICK:register(function()
	if client:isPaused() then
		return
	end

	d = 0.05

	tickTime = tickTime + d
	tailTime = tailTime + d * tailSpeed

	t1 = erp(t1, t1T, d, ts)
	t2 = erp(t2, t2T, d, ts)
	t3 = erp(t3, t3T, d, ts)
	tailAngle = erp(tailAngle, tailAngleT, d, as)
	tailSpeed = erp(tailSpeed, tailSpeedT, d, tailRate)

	hunger = 1.0 - player:getFood() / 20.0
	health = player:getHealth()

	pain = 0.0

	pain = pain + math.map(math.clamp(hunger, 0.0, starvingThreshold), 0.0, starvingThreshold, 0.0, hungerPain)
	pain = pain + math.map(math.clamp(hunger, starvingThreshold, 1.0), starvingThreshold, 1.0, 0.0, starvingPain)
	pain = pain + math.map(1.0 - health / 20.0, 0.0, 1.0, 0.0, damagePain)

	pain = math.clamp(math.round(pain), 0, 2)

	SetPain(pain)

	if health < lhealth then
		damageTimer = damageReset
	end
	
	lhealth = health

	if player:isUnderwater() then
		wetness = wetness + waterRate * d
	elseif player:isInRain() then
		wetness = wetness + rainRate * d
	elseif not player:isWet() then
		wetness = wetness - dryRate * d
	end

	wetness = math.clamp(wetness, 0, 1)

	if (not player:isUnderwater()) and wetness > 0 then
		dropCounter = dropCounter - wetness * dropRate * d
		while dropCounter < 0 do
			dropCounter = dropCounter + math.random(75, 125) / 100

			v = randFaceVec(-0.3, 0, -0.2, 0.3, 1.375, 0.2)
			particles:newParticle("falling_dripstone_water", v)
		end
	end

	if host:isHost() then
		_nightVision = 0
		_fireproof = false
		_blindness = false
		_levitating = false
		_hero = false

		statuses = client.getViewer():getStatusEffects()

		for k, v in pairs(statuses) do
			if v.name == "effect.minecraft.night_vision" then
				_nightVision = math.ceil(math.clamp(v.duration * (15 / 3600), 0, 15))
			elseif v.name == "effect.minecraft.fire_resistance" then
				_fireproof = true
			elseif v.name == "effect.minecraft.blindness" then
				_blindness = true
			elseif v.name == "effect.minecraft.levitation" then
				_levitating = true
			elseif v.name == "effect.minecraft.hero_of_the_village" then
				_hero = true
			end
		end

		ifNeq(_nightVision, nightVision, pings.nightVisionPing)
		ifNeq(_fireproof,   fireproof,   pings.fireproofPing  )
		ifNeq(_blindness,   blindness,   pings.blindPing      )
		ifNeq(_levitating,  levitating,  pings.levitatingPing )
		ifNeq(_hero,        hero,        pings.heroPing       )
	end
end)

lt1 = 0.0

function ifNeq(a, b, f)
	if a ~= b then
		f(a)
	end
end

events.RENDER:register(function(delta, context)
	if context == 'PAPERDOLL' or context == 'MINECRAFT_GUI' then
		return
	end

	t = tickTime + delta * 0.05
	d = t - lt1

	if d <= 0 then
		return
	end

	gamemode = player:getGamemode()
	vehicle = player:getVehicle()

	pose = player:getPose()

	look = player:getLookDir()
	angle = math.rad(player:getBodyYaw(delta) + 90)
	
	v = player:getVelocity()
	hv = vectors.vec(
		v.x * math.sin(-angle) + v.z * math.cos(-angle),
		v.x * math.cos(-angle) - v.z * math.sin(-angle)
	)

	t1T = 37.5
	t2T = 25.0
	t3T = 10.0
	ts = 0.1
	tailAngleT = A
	tailSpeedT = 1.0 / 4.0
	tailRate = 1.0

	if vehicle then
		if vehicle:getType() == "minecraft:minecart" or vehicle:getType() == "minecraft:boat" then
			t1T = 60
			t2T = 80
			t3T = 30
		else
			t1T = 5
			t2T = 5
			t3T = 10
		end
		ts = 0.1
		tailAngleT = A / 2
		tailSpeedT = 1.0 / 8.0
		tailRate = 0.25
	elseif player:isCrouching() and player:isOnGround() then
		t1T = 37.5
		t2T = 25.0
		t3T = 10.0
		tailAngleT = A / 2
		tailSpeedT = 1.0 / 6.0
		tailRate = 2.0
	elseif player:isInLava() or player:isInWater() or player:isClimbing() or player:isGliding() then

	else
		tailAngleT = 1.0
		ts = 0.1

		if hv.y > 0 then
			-- 0.21585
			-- 0.28061
			t1T = erp(t1T, 5.0, math.max(0, hv:length() - 0.145), 0.08)
			t2T = erp(t2T, 5.0, math.max(0, hv:length() - 0.145), 0.08)
			tailSpeedT = erp(tailSpeedT, 1.25, hv:length() - 0.2, 0.04)
			tailAngleT = erp(tailAngleT, 5.0, hv:length() - 0.2, 0.04)
			tailRate = erp(tailRate, 0.1, hv:length() - 0.18, 0.03)
		else
			t1T = erp(t1T, 42.5, hv:length(), 0.1)
			t2T = erp(t2T, 30.0, hv:length(), 0.1)
		end

		if v.y < 0 then
			t1T = erp(t1T, -60.0, -v.y, 0.1)
			t2T = erp(t2T, -5.0, -v.y, 0.1)
			t3T = erp(t3T, -5.0, -v.y, 0.1)

			ts = 1.0 / 2.0

			tailSpeedT = erp(tailSpeedT, 1.25, v:length(), 0.25)
			tailAngleT = erp(tailAngleT, 4.0, v:length(), 0.25)
		elseif v.y > 0 then
			t1T = erp(t1T, 60.0, v.y, 0.07)
			t2T = erp(t2T, 20.0, v.y, 0.07)
			t3T = erp(t3T, 5.0, v.y, 0.07)

			ts = 1.0 / 5.0
		end

		tailAngleT = tailAngleT * A
	end

	SetWetness(d)

	_tail = tailTime + delta * 0.05 * tailSpeed
	_tailAngle = erp(tailAngle, tailAngleT, delta * 0.05, as)

	_t1 = erp(t1, t1T, delta * 0.05, ts)
	_t2 = erp(t2, t2T, delta * 0.05, ts)
	_t3 = erp(t3, t3T, delta * 0.05, ts)

	tail_0:setRot(_t1, wag(_tailAngle, _tail, 0.000), 0)
	tail_1:setRot(_t2, wag(_tailAngle, _tail, -0.125), 0)
	tail_2:setRot(_t3, wag(_tailAngle, _tail, -0.250), 0)

	blinkTime = blinkTime - d

	if blinkTime < -blinkDur then
		blinkTime = math.random(blinkMin, blinkMax)
	end

	canBlink = true;

	neutralBrows = nil
	suprisedBrows = 4
	neutralLBrowR = 0
	neutralRBrowR = 0

	if brow then
		if browSerious then
			neutralBrows = 2
			neutralRBrowR = 0
			neutralLBrowR = 1
		else
			neutralBrows = 4
			neutralRBrowR = 1
			neutralLBrowR = 2
		end
	elseif browSerious then
		neutralBrows = 2
		suprisedBrows = 2
	end

	if currentPain == 2 then
		neutralBrows = 2
		suprisedBrows = 2
	end

	if not player:isAlive() then
		SetEyes(3)
		SetBrows(1)

		canBlink = false;
	elseif damageTimer > 0 then
		SetEyes(3)
		SetBrows(1)
		damageTimer = damageTimer - d
		canBlink = false;
	elseif blindness then
		SetEyes(3)
		SetBrows(2)
		canBlink = false
	elseif levitating or player:isGlowing() or (gamemode == "SURVIVAL" or gamemode == "ADVENTURE") and (
		(player:isOnFire() and not fireproof)
		or (vehicle and vehicle:getType() == "minecraft:minecart" and v:length() > cartSurpriseSpeed)
		or hv:length() > surpriseSpeed
		or v.y < -fallSurpriseSpeed) then
		SetEyes(4)
		SetBrows(suprisedBrows)
		SetBrowsR(2)
	elseif player:isUnderwater() then
		SetEyes(1)
		neutralBrows = neutralBrows or 2
		SetBrows(neutralBrows)
		SetBrowsR(neutralLBrowR, neutralRBrowR)
		squint:setVisible(true)
	elseif pose == "SLEEPING" then
		SetEyes(2)
		SetBrows(neutralBrows)
		SetBrowsR(0)
		canBlink = false;
	elseif cute then
		SetEyes(5)
		if browSerious then
			if brow then
				SetBrows(2)
				SetBrowsR(2,1)
			else
				SetBrows(2)
				SetBrowsR(1)
			end
		else
			if brow then
				SetBrows(2, 4)
				SetBrowsR(2)
			else
				SetBrows(suprisedBrows)
				SetBrowsR(2)
			end
		end
	else
		SetEyes(0)
		SetBrows(neutralBrows)
		SetBrowsR(neutralLBrowR, neutralRBrowR)
	end

	blush:visible(blushing or hero)

	Blink(canBlink and blinkTime <= 0)

	if wearingHat then
		learAngleT = -60
		rearAngleT = -60
		learAngle = -60
		rearAngle = -60
	else
		twitchTimer = twitchTimer - d
		if twitchTimer <= -twitchDur and host:isHost() then
			pings.resetTwitchPing(math.random(twitchMinReset * 100.0, twitchMaxReset * 100.0) / 100.0, math.random(0,1) == 0)
		elseif twitchTimer <= 0 then
			if twitchleft then
				learAngleT = lear:getOffsetRot().x - 10
			else
				rearAngleT = rear:getOffsetRot().x - 10
			end
		end
	end

	learAngle = erp(learAngle, learAngleT, d, 0.05)
	rearAngle = erp(rearAngle, rearAngleT, d, 0.05)

	lear:offsetRot(learAngle, 0, 0)
	rear:offsetRot(rearAngle, 0, 0)

	lt1 = t
	lhealth = health
end)

function Blink(b)
	eyes:setVisible(not b)
end

function SetLBrow(b)
	if b == currentLBrow then
		return
	end

	currentLBrow = b

	uv = lbrow:getUV()

	uv.x = (b * 2) / UVres

	lbrow:setUV(uv)
end

function SetRBrow(b)
	if b == currentRBrow then
		return
	end

	currentRBrow = b

	uv = rbrow:getUV()

	uv.x = (b * 2) / UVres

	rbrow:setUV(uv)
end

function SetLBrowR(r)
	if r == currentLBrowR then
		return
	end

	currentLBrowR = r

	uv = lbrow:getUV()

	uv.y = r / UVres

	lbrow:setUV(uv)
end

function SetRBrowR(r)
	if r == currentRBrowR then
		return
	end

	currentRBrowR = r

	uv = rbrow:getUV()

	uv.y = r / UVres

	rbrow:setUV(uv)
end

function SetBrows(l, r)
	l = l or 0
	r = r or l

	SetLBrow(l)
	SetRBrow(r)
end

function SetBrowsR(l, r)
	l = l or 0
	r = r or l

	SetLBrowR(l)
	SetRBrowR(r)
end

function SetEyes(e)
	if e == currentEyes then
		return
	end

	currentEyes = e

	uv = eyes:getUV()

	uv.x = (e * 2) / UVres

	eyes:setUV(uv)
end

function SetPain(p)
	if p == currentPain then
		return
	end

	currentPain = p

	uv = facePain:getUV()

	uv.x = (p * 3) / UVres

	facePain:setUV(uv)
end

function randFaceVec(minx, miny, minz, maxx, maxy, maxz)
	xArea = (maxy - miny) * (maxz - minz)
	yArea = (maxx - minx) * (maxz - minz)
	zArea = (maxx - minx) * (maxy - miny)
	tArea = xArea + yArea
	
	xArea = xArea / tArea * 100

	sel = math.random(0, 100)

	v = vectors.vec(0,0,0)

	v = vectors.vec(
		math.random(minx * 100, maxx * 100) / 100,
		math.random(miny * 100, maxy * 100) / 100,
		math.random(minz * 100, maxz * 100) / 100
	)

	if sel < xArea then
		v.x = math.round((v.x - minx) / (maxx - minx)) * (maxx - minx) + minx
	else
		v.y = math.round((v.y - miny) / (maxy - miny)) * (maxy - miny) + miny
	end

	angle = math.rad(player:getBodyYaw(delta))
	v = vectors.vec(
		v.x * math.cos(angle) - v.z * math.sin(angle),
		v.y,
		v.x * math.sin(angle) + v.z * math.cos(angle)
	)
	return v + player:getPos()
end

function SetWetness(delta)
	_wetness = wetness

	if player:isUnderwater() then
		wetness = wetness + waterRate * delta
	elseif player:isInRain() then
		wetness = wetness + rainRate * delta
	elseif not player:isWet() then
		wetness = wetness - dryRate * delta
	end

	_wetness = math.clamp(_wetness, 0, 1)

	sWetness = 1 / (1 + 2 ^ (16 * (0.5 - _wetness)))

	ltuft1:setRot(0, 0, 20.0 * sWetness)
	ltuft2:setRot(0, 0, 15.0 * sWetness)
	rtuft1:setRot(0, 0, -20.0 * sWetness)
	rtuft2:setRot(0, 0, -15.0 * sWetness)

	learAngleT = -30 * sWetness
	rearAngleT = -30 * sWetness
end
