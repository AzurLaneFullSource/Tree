local var0 = class("BeachGuardSceneMgr")

local function var1(arg0, arg1, arg2)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._charTpl = arg1
			arg0._event = arg2
			arg0.chars = {}
			arg0.charPool = {}
			arg0.gridChars = {}
			arg0.enemys = {}
			arg0.enemysPool = {}
			arg0.content = findTF(arg0._tf, "sceneContainer/scene/content")
		end,
		changeRecycles = function(arg0, arg1)
			arg0.recycle = arg1

			for iter0 = #arg0.chars, 1, -1 do
				arg0.chars[iter0]:setRecycleFlag(arg1)
			end
		end,
		setGridChar = function(arg0, arg1, arg2)
			local var0 = arg2:getPos()
			local var1 = arg0:createChar(arg1)
			local var2 = arg0.content:InverseTransformPoint(var0.position)

			var1:prepareData()
			var1:setParent(arg0.content, true, var2)
			var1:setLineIndex(arg2:getLineIndex())
			var1:setGridIndex(arg2:getIndex())
			var1:setCamp(1)
			var1:setRaycast(true)
			table.insert(arg0.chars, var1)

			return var1
		end,
		createChar = function(arg0, arg1)
			local var0 = arg0:getCharFromPool(arg1)

			if not var0 then
				local var1 = BeachGuardConst.chars[arg1]

				var0 = BeachGuardChar.New(tf(instantiate(arg0._charTpl)), var1, arg0._event)
			end

			return var0
		end,
		getCharFromPool = function(arg0, arg1)
			for iter0 = #arg0.charPool, 1, -1 do
				if arg0.charPool[iter0]:getId() == arg1 then
					return table.remove(arg0.charPool, iter0)
				end
			end

			return nil
		end,
		removeChar = function(arg0, arg1)
			for iter0 = #arg0.chars, 1, -1 do
				if arg0.chars[iter0] == arg1 then
					local var0 = table.remove(arg0.chars, iter0)

					var0:clear()
					table.insert(arg0.charPool, var0)
				elseif arg0.chars[iter0]:getTarget() == arg1 then
					arg0.chars[iter0]:setTarget(nil)
				end
			end

			for iter1 = #arg0.enemys, 1, -1 do
				if arg0.enemys[iter1] == arg1 then
					local var1 = table.remove(arg0.enemys, iter1)

					var1:clear()
					table.insert(arg0.charPool, var1)
				elseif arg0.enemys[iter1]:getTarget() == arg1 then
					arg0.enemys[iter1]:setTarget(nil)
				end
			end
		end,
		clear = function(arg0)
			for iter0 = #arg0.chars, 1, -1 do
				local var0 = table.remove(arg0.chars, iter0)

				var0:clear()
				table.insert(arg0.charPool, var0)
			end

			for iter1 = #arg0.enemys, 1, -1 do
				local var1 = table.remove(arg0.enemys, iter1)

				var1:clear()
				table.insert(arg0.charPool, var1)
			end
		end,
		start = function(arg0)
			for iter0 = #arg0.chars, 1, -1 do
				arg0.chars[iter0]:start()
			end

			arg0.recycle = false
		end,
		step = function(arg0, arg1)
			for iter0 = #arg0.chars, 1, -1 do
				arg0.chars[iter0]:step(arg1)
			end

			for iter1 = #arg0.enemys, 1, -1 do
				arg0.enemys[iter1]:step(arg1)
			end

			arg0.enemyOver = false

			for iter2 = #arg0.enemys, 1, -1 do
				local var0 = arg0.enemys[iter2]

				if not var0:getTarget() then
					local var1 = var0:getLineIndex()
					local var2 = var0:getPointWorld()
					local var3 = var0:getPos()
					local var4 = arg0:getCharLine(var1)
					local var5 = false

					for iter3, iter4 in ipairs(var4) do
						if iter4:checkCollider(var2, var3) and (not var5 or true) then
							var5 = true

							var0:setTarget(iter4)
						end
					end
				end

				if var0:getPos().x < BeachGuardConst.enemy_over_width then
					arg0.enemyOver = true
				end
			end

			for iter5 = 1, #arg0.chars do
				local var6 = arg0.chars[iter5]
				local var7 = var6:getSkillDistance() * BeachGuardConst.part_width
				local var8 = arg0:getCanHitChar(var6:getLineIndex(), var6:getCamp())

				for iter6, iter7 in ipairs(var8) do
					local var9 = iter7:getPos().x - var6:getPos().x

					if var9 > 0 and var9 < var7 then
						var6:setTarget(iter7)
					end
				end
			end

			arg0:sortChar()
		end,
		stop = function(arg0)
			for iter0 = #arg0.chars, 1, -1 do
				arg0.chars[iter0]:stop()
			end
		end,
		getLineCampChars = function(arg0, arg1, arg2)
			local var0 = {}
			local var1 = {}

			if arg2 == 1 then
				var1 = arg0.chars
			elseif arg2 == 2 then
				var1 = arg0.enemys
			end

			for iter0 = 1, #var1 do
				local var2 = var1[iter0]

				if table.contains(arg1, var2:getLineIndex()) then
					table.insert(var0, var2)
				end
			end

			return var0
		end,
		getCharByCamp = function(arg0, arg1)
			local var0 = {}

			if arg1 == 1 then
				var0 = arg0.chars
			elseif arg1 == 2 then
				var0 = arg0.enemys
			end

			return var0
		end,
		getEnemyOver = function(arg0)
			return arg0.enemyOver
		end,
		getCanHitChar = function(arg0, arg1, arg2)
			local var0 = {}
			local var1 = {}

			if arg2 == 1 then
				var1 = arg0.enemys
			elseif arg2 == 2 then
				var1 = arg0.chars
			end

			for iter0 = 1, #var1 do
				local var2 = var1[iter0]

				if var2:getLineIndex() == arg1 and var2:inBulletBound() then
					table.insert(var0, var2)
				end
			end

			return var0
		end,
		getChars = function(arg0)
			return arg0.chars
		end,
		getEnemys = function(arg0)
			return arg0.enemys
		end,
		getCharLine = function(arg0, arg1)
			local var0 = {}

			for iter0 = 1, #arg0.chars do
				local var1 = arg0.chars[iter0]

				if var1:getLineIndex() == arg1 then
					table.insert(var0, var1)
				end
			end

			return var0
		end,
		addEnemyChar = function(arg0, arg1, arg2)
			local var0 = arg1
			local var1 = arg0:createChar(var0)

			var1:prepareData()
			var1:setLineIndex(arg2.index)

			local var2 = arg0.content:InverseTransformPoint(arg2.position)
			local var3 = math.random(BeachGuardConst.enemy_pos[1], BeachGuardConst.enemy_pos[2])

			var1:setParent(arg0.content, false, Vector2(var3 + var2.x, var2.y + BeachGuardConst.enemy_offset_y))
			var1:setCamp(2)
			var1:setRaycast(false)
			table.insert(arg0.enemys, var1)
		end,
		sortChar = function(arg0)
			local var0 = #arg0.chars + #arg0.enemys

			if not arg0.sorts or #arg0.sorts ~= var0 then
				arg0.sorts = {}

				for iter0 = 1, #arg0.chars do
					table.insert(arg0.sorts, arg0.chars[iter0])
				end

				for iter1 = 1, #arg0.enemys do
					table.insert(arg0.sorts, arg0.enemys[iter1])
				end

				table.sort(arg0.sorts, function(arg0, arg1)
					local var0 = arg0:getPos()
					local var1 = arg1:getPos()

					if var0.y > var1.y then
						return true
					elseif var0.y < var1.y then
						return false
					end

					if var0.x > var1.x then
						return true
					elseif var0.x < var1.x then
						return false
					end
				end)

				for iter2 = 1, #arg0.sorts do
					arg0.sorts[iter2]:SetSiblingIndex(iter2)
				end
			end
		end
	}

	var0:Ctor()

	return var0
end

local function var2(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.lineTpl = findTF(arg0._tf, "sceneContainer/scene/classes/lineTpl")
			arg0.gridTpl = findTF(arg0._tf, "sceneContainer/scene/classes/gridTpl")
			arg0.lines = {}
			arg0.content = findTF(arg0._tf, "sceneContainer/scene/content")

			for iter0 = 1, BeachGuardConst.line_num do
				local var0 = findTF(arg0._tf, "sceneContainer/scene/linePos/" .. iter0)
				local var1 = tf(instantiate(arg0.lineTpl))

				var1.anchoredPosition = Vector2(0, 0)

				setParent(var1, var0)

				local var2 = BeachGuardLine.New(var1, arg0.gridTpl, arg0._event)

				var2:setIndex(iter0)
				table.insert(arg0.lines, var2)
			end
		end,
		setMapData = function(arg0, arg1)
			local var0 = arg1.line

			arg0.activeLines = {}

			for iter0 = 1, #arg0.lines do
				local var1 = arg0.lines[iter0]

				if table.contains(var0, var1:getIndex()) then
					var1:active(true)
					table.insert(arg0.activeLines, var1)
				else
					var1:active(false)
				end
			end
		end,
		getGridByIndex = function(arg0, arg1, arg2)
			for iter0 = 1, #arg0.activeLines do
				local var0 = arg0.activeLines[iter0]

				if var0:getIndex() == arg1 then
					return var0:getGridByIndex(arg2)
				end
			end

			return nil
		end,
		setDrag = function(arg0, arg1)
			arg0.dragData = arg1
		end,
		start = function(arg0)
			for iter0 = 1, #arg0.lines do
				local var0 = arg0.lines[iter0]:start()
			end
		end,
		step = function(arg0, arg1)
			for iter0 = 1, #arg0.lines do
				local var0 = arg0.lines[iter0]:step(arg1)
			end
		end,
		clear = function(arg0)
			arg0:clearPre()

			for iter0 = 1, #arg0.lines do
				arg0.lines[iter0]:clear()
			end
		end,
		onTimer = function(arg0)
			if not arg0.dragData then
				return
			end

			if arg0.dragData.flag ~= true or not arg0.dragData.pos then
				if arg0.preCharGrid then
					arg0._event:emit(BeachGuardGameView.PULL_CHAR, {
						card_id = arg0.preCardID,
						line_index = arg0.preCharGrid:getLineIndex(),
						grid_index = arg0.preCharGrid:getIndex()
					})
				end

				arg0:clearPre()

				return
			end

			local var0 = arg0.dragData.pos
			local var1 = arg0:getGridByWorld(var0)

			if var1 and var1:isEmpty() then
				local var2 = arg0.dragData.config
				local var3 = var2.char_id
				local var4 = var2.id

				if arg0.preCharGrid == var1 and arg0.preCardID == var4 then
					return
				end

				arg0:clearPre()

				arg0.preCharGrid = var1
				arg0.preCardID = var4

				arg0.preCharGrid:prechar(var3)

				local var5 = arg0.preCharGrid:getLineIndex()
				local var6 = arg0.preCharGrid:getIndex()

				if var5 and var6 then
					local var7 = BeachGuardConst.chars[var3].distance

					for iter0 = 1, var7 do
						local var8 = arg0:getGridByIndex(var5, var6 + iter0)

						if var8 then
							var8:preDistance()
							table.insert(arg0.preDistanceGrids, var8)
						end
					end
				end
			else
				arg0:clearPre()
			end
		end,
		clearPre = function(arg0)
			if arg0.preCharGrid then
				arg0.preCharGrid:unPreChar()

				arg0.preCharGrid = nil
			end

			if arg0.preDistanceGrids and #arg0.preDistanceGrids > 0 then
				for iter0 = 1, #arg0.preDistanceGrids do
					arg0.preDistanceGrids[iter0]:unPreDistance()
				end
			end

			arg0.preDistanceGrids = {}
		end,
		removeGridChar = function(arg0, arg1)
			local var0 = arg0:getGridByChar(arg1)

			if var0 then
				var0:removeChar()

				return true
			end
		end,
		getGridByWorld = function(arg0, arg1)
			for iter0 = 1, #arg0.activeLines do
				local var0 = arg0.activeLines[iter0]:getGridWorld(arg1)

				if var0 then
					return var0
				end
			end

			return nil
		end,
		getGridByChar = function(arg0, arg1)
			for iter0 = 1, #arg0.lines do
				local var0 = arg0.lines[iter0]:getGrids()

				for iter1, iter2 in ipairs(var0) do
					if iter2:getChar() == arg1 then
						return iter2
					end
				end
			end

			return nil
		end,
		getAbleLinePos = function(arg0, arg1)
			local var0 = {}

			for iter0 = 1, #arg0.activeLines do
				local var1 = arg0.activeLines[iter0]:getIndex()

				if table.contains(arg1, var1) then
					table.insert(var0, {
						position = arg0.activeLines[iter0]:getPosition(),
						index = var1
					})
				end
			end

			return var0[math.random(1, #var0)]
		end
	}

	var0:Ctor()

	return var0
end

local function var3(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.content = findTF(arg0._tf, "sceneContainer/scene/content")
			arg0.bullets = {}
			arg0.bulletPool = {}
		end,
		useSkill = function(arg0, arg1)
			local var0 = arg1.skill

			if var0.type == BeachGuardConst.skill_craft then
				arg0._event:emit(BeachGuardGameView.ADD_CRAFT, {
					num = var0.num
				})
			elseif var0.type == BeachGuardConst.skill_bullet then
				local var1 = var0.bullet_id

				for iter0, iter1 in ipairs(var1) do
					arg0:pullBullet(iter1, arg1)
				end
			elseif var0.type == BeachGuardConst.skill_melee then
				local var2 = arg1.damage
				local var3 = arg1.target
				local var4 = arg1.position

				arg0._event:emit(BeachGuardGameView.CREATE_CHAR_DAMAGE, {
					damage = var2,
					position = var4,
					target = var3,
					useData = arg1
				})
			end
		end,
		pullBullet = function(arg0, arg1, arg2)
			local var0 = arg0:getOrCreateBullet(arg1)
			local var1 = arg2.position
			local var2 = arg2.distanceVec
			local var3 = var0.config.offset

			var0.tf.anchoredPosition = arg0.content:InverseTransformPoint(var1)

			if var3 then
				var0.tf.anchoredPosition = Vector2(var0.tf.anchoredPosition.x + var3.x, var0.tf.anchoredPosition.y + var3.y)
			end

			setActive(var0.tf, true)

			var0.distanceVec = var2
			var0.speed = Vector2(var0.config.speed[1], var0.config.speed[2])
			var0.direct = arg2.direct
			var0.hit = false
			var0.useData = arg2

			if var0.config.point_able then
				var0.life = nil
			elseif var0.config.speed_high and var0.config.speed_high ~= 0 then
				local var4 = arg2.target:getPos()
				local var5 = math.random(-10, 5)

				var4.x = var4.x + 5 - math.random() * 15

				local var6 = arg2.useChar:getPos()

				if var4 and var6 then
					var0.life = math.abs(var4.x - var6.x) / math.abs(var0.speed.x)
				else
					var0.life = math.abs(var0.distanceVec.x) / math.abs(var0.speed.x)
				end
			else
				var0.life = math.abs(var0.distanceVec.x) / math.abs(var0.speed.x)
			end

			var0.gravity = 0

			if var0.config.speed_high and var0.config.speed_high ~= 0 then
				local var7 = -(var0.config.speed_high * 2) / math.pow(var0.life / 2, 2)

				var0.speed.y = math.abs(var7) * (var0.life / 2)
				var0.gravity = var7
			end

			table.insert(arg0.bullets, var0)
		end,
		getBullets = function(arg0)
			return arg0.bullets
		end,
		getOrCreateBullet = function(arg0, arg1)
			local var0 = arg0:getBulletFromPool(arg1)

			if not var0 then
				local var1 = BeachGuardConst.bullet[arg1]
				local var2 = BeachGuardAsset.getBullet(var1.name)

				setParent(var2, arg0.content)

				var0 = {
					tf = var2,
					config = var1
				}
			end

			return var0
		end,
		getBulletFromPool = function(arg0, arg1)
			for iter0 = #arg0.bulletPool, 1, -1 do
				if arg0.bulletPool[iter0].config.id == arg1 then
					return table.remove(arg0.bulletPool, iter0)
				end
			end

			return nil
		end,
		finishBullet = function(arg0, arg1)
			local var0 = arg1.config.damage

			setActive(arg1.tf, false)

			local var1 = arg1.tf.anchoredPosition
		end,
		start = function(arg0)
			return
		end,
		step = function(arg0, arg1)
			for iter0 = #arg0.bullets, 1, -1 do
				local var0 = arg0.bullets[iter0]
				local var1 = var0.speed
				local var2 = var0.gravity
				local var3 = var0.direct

				var0.tf.anchoredPosition = Vector2(var0.tf.anchoredPosition.x + var1.x * arg1 * var3, var0.tf.anchoredPosition.y + var1.y * arg1)
				var0.speed.y = var0.speed.y + var0.gravity * arg1

				if var0.life then
					var0.life = var0.life - arg1

					if var0.life <= 0 then
						if var0.config.speed_high and var0.config.speed_high ~= 0 and not var0.hit then
							local var4 = var0.config.damage

							var0.useData.target = nil

							arg0._event:emit(BeachGuardGameView.BULLET_DAMAGE, {
								damage = var4,
								position = var0.tf.position,
								useData = var0.useData
							})
						end

						local var5 = table.remove(arg0.bullets, iter0)

						arg0:finishBullet(var5)
						table.insert(arg0.bulletPool, var5)
					elseif var0.hit then
						local var6 = table.remove(arg0.bullets, iter0)

						arg0:finishBullet(var6)
						table.insert(arg0.bulletPool, var6)
					end
				end
			end
		end,
		stop = function(arg0)
			return
		end,
		clear = function(arg0)
			for iter0 = #arg0.bullets, 1, -1 do
				local var0 = table.remove(arg0.bullets, iter0)

				setActive(var0.tf, false)

				var0.distanceVec = nil

				table.insert(arg0.bulletPool, var0)
			end
		end
	}

	var0:Ctor()

	return var0
end

local function var4(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
		end,
		setData = function(arg0, arg1)
			arg0._data = arg1
			arg0._chapterId = arg0._data.id
		end,
		start = function(arg0)
			arg0:clear()

			arg0._chapterDatas = Clone(arg0._data.data)
		end,
		step = function(arg0, arg1)
			arg0._overTime = arg0._overTime + arg1

			for iter0 = #arg0._chapterDatas, 1, -1 do
				if arg0._chapterDatas[iter0].time < arg0._overTime then
					local var0 = arg0:createData(table.remove(arg0._chapterDatas, iter0))

					table.insert(arg0.enemyDatas, var0)
				end
			end

			for iter1 = #arg0.enemyDatas, 1, -1 do
				local var1 = arg0.enemyDatas[iter1]

				if var1.loop then
					var1.stepTime = var1.stepTime - arg1

					if var1.stepTime <= 0 then
						local var2 = var1.step

						var1.stepTime = math.random() * (var2[2] - var2[1]) + var2[1]

						arg0:addEnemyData(var1)
					end

					if arg0._overTime > var1.stop then
						table.remove(arg0.enemyDatas, iter1)
					end
				else
					arg0:addEnemyData(var1)
					table.remove(arg0.enemyDatas, iter1)
				end
			end

			if not arg0.addEnemyTime then
				arg0.addEnemyTime = 1
			end

			arg0.addEnemyTime = arg0.addEnemyTime - arg1

			if #arg0.enemyList > 0 and arg0.addEnemyTime <= 0 then
				local var3 = table.remove(arg0.enemyList, #arg0.enemyList)

				arg0._event:emit(BeachGuardGameView.ADD_ENEMY, var3)
			end

			if #arg0.enemyDatas == 0 and #arg0._chapterDatas == 0 and #arg0.enemyList == 0 then
				arg0.finishCreate = true
			end
		end,
		getFinishCreate = function(arg0)
			return arg0.finishCreate
		end,
		createData = function(arg0, arg1)
			local var0 = {}
			local var1 = arg1.create
			local var2 = arg1.time
			local var3 = arg1.stop
			local var4 = arg1.step
			local var5 = arg1.comming

			if var4 then
				var0.loop = true
				var0.stepTime = 0
			else
				var0.loop = false
			end

			var0.create = var1
			var0.time = var2
			var0.stop = var3
			var0.step = var4
			var0.comming = var5

			return var0
		end,
		addEnemyData = function(arg0, arg1)
			local var0 = arg1.create

			if arg1.comming or false then
				arg1.comming = false

				arg0._event:emit(BeachGuardGameView.ENEMY_COMMING)
			end

			local var1 = BeachGuardConst.create_enemy[var0]

			for iter0 = 1, var1.num do
				local var2 = var1.enemy[math.random(1, #var1.enemy)]
				local var3 = var1.line

				table.insert(arg0.enemyList, {
					id = var2,
					lines = var3
				})
			end
		end,
		stop = function(arg0)
			return
		end,
		clear = function(arg0)
			arg0._overTime = 0
			arg0._chapterDatas = {}
			arg0.enemyDatas = {}
			arg0.enemyList = {}
			arg0.finishCreate = false
		end
	}

	var0:Ctor()

	return var0
end

local function var5(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.effectBackTf = findTF(arg0._tf, "sceneContainer/scene/effect_back")
			arg0.effectFrontTf = findTF(arg0._tf, "sceneContainer/scene/effect_front")
			arg0.content = findTF(arg0._tf, "sceneContainer/scene/content")
			arg0.effects = {}
			arg0.effectPool = {}
		end,
		setCharCtrl = function(arg0, arg1)
			arg0.charCtrl = arg1
		end,
		setSkillCtrl = function(arg0, arg1)
			arg0.skillCtrl = arg1
		end,
		craeteCharDamage = function(arg0, arg1)
			arg0:createDamage(arg1)
		end,
		bulletDamage = function(arg0, arg1)
			arg0:createDamage(arg1)
		end,
		createDamage = function(arg0, arg1)
			local var0 = arg1.damage
			local var1 = arg1.position
			local var2 = arg1.useData
			local var3 = var2.target
			local var4 = var2.line
			local var5 = var2.camp

			if not var0 then
				-- block empty
			end

			local var6 = BeachGuardConst.damage[var0]

			if var3 then
				local var7 = var2.atkRate or 1

				var3:damage(var6.damage * var7)
			end

			if var6.type == BeachGuardConst.bullet_type_range then
				local var8 = var6.config
				local var9 = var8.next
				local var10 = var8.range
				local var11 = var5 == 1 and 2 or 1
				local var12 = arg0.charCtrl:getLineCampChars({
					var4 + 1,
					var4 - 1,
					var4
				}, var11)
				local var13

				if var2.target then
					var13 = var2.target:getPos()
				else
					var13 = arg0.effectFrontTf:InverseTransformPoint(var1)
				end

				if var12 and #var12 > 0 then
					local var14 = var10 * BeachGuardConst.part_width

					for iter0 = 1, #var12 do
						local var15 = var12[iter0]

						if (not var2.target or var2.target ~= var15) and var14 > math.abs(var13.x - var15:getPos().x) then
							local var16 = var15:getWorldPos()
							local var17 = Clone(var2)

							var17.target = var15

							arg0:createDamage({
								damage = var8.next,
								position = var16,
								useData = var17
							})
						end
					end
				end
			elseif var6.type == BeachGuardConst.bullet_type_disperse then
				local var18 = var6.config
				local var19 = var18.up
				local var20 = var18.down
				local var21 = var5 == 1 and 2 or 1

				arg0:addDamageByDisperse({
					var4 - 1
				}, var18.range, var21, var19, var2)
				arg0:addDamageByDisperse({
					var4 + 1
				}, var18.range, var21, var20, var2)
			end

			if var6.buff and #var6.buff > 0 then
				for iter1 = 1, #var6.buff do
					local var22 = var6.buff[iter1]
					local var23 = BeachGuardConst.buff[var22]
					local var24 = var23.type
					local var25 = var23.trigger
					local var26 = var23.bound
					local var27 = var2.useChar
					local var28 = var2.target

					if var25 == BeachGuardConst.buff_trigger_other then
						var28:addBuff(var23)
					elseif var25 == BeachGuardConst.buff_trigger_self then
						var27:addBuff(var23)

						if var26 and var26 ~= nil then
							local var29 = var2.useChar:getCamp()
							local var30 = var2.useChar:getLineIndex()
							local var31 = var2.useChar:getGridIndex()

							if var30 and var31 then
								local var32 = arg0.charCtrl:getCharByCamp(var29)

								for iter2, iter3 in ipairs(var32) do
									if iter3 ~= var27 then
										local var33 = iter3:getGridIndex()
										local var34 = iter3:getLineIndex()

										if math.abs(var33 - var31) <= var26[1] and math.abs(var34 - var30) <= var26[2] then
											iter3:addBuff(var23)
										end
									end
								end
							end
						end
					end
				end
			end

			if var6.effect and #var6.effect > 0 then
				arg0:createEffect(var6.effect, var1)
			end
		end,
		addDamageByDisperse = function(arg0, arg1, arg2, arg3, arg4, arg5)
			local var0 = arg0.charCtrl:getLineCampChars(arg1, arg3)

			if var0 and #var0 > 0 then
				local var1 = arg2 * BeachGuardConst.part_width
				local var2 = arg5.target:getPos()

				for iter0 = 1, #var0 do
					local var3 = var0[iter0]
					local var4 = var3:getPos()

					if var1 > math.abs(var2.x - var4.x) then
						local var5 = var3:getWorldPos()
						local var6 = Clone(arg5)

						var6.target = var3

						arg0:createDamage({
							damage = arg4,
							position = var5,
							useData = var6
						})
					end
				end
			end
		end,
		createEffect = function(arg0, arg1, arg2)
			local var0 = arg0:getEffect(arg1[1])

			if not var0 then
				-- block empty
			end

			if not var0 then
				return
			end

			var0.tf.anchoredPosition = arg0.effectFrontTf:InverseTransformPoint(arg2)

			setActive(var0.tf, true)

			var0.time = var0.config.time

			table.insert(arg0.effects, var0)
		end,
		getEffect = function(arg0, arg1)
			local var0

			if #arg0.effectPool > 0 then
				for iter0 = #arg0.effectPool, 1, -1 do
					if arg0.effectPool[iter0].config.id == arg1 then
						return (table.remove(arg0.effectPool, iter0))
					end
				end
			end

			local var1 = BeachGuardConst.effect[arg1]
			local var2 = BeachGuardAsset.getEffect(var1.name)

			setParent(var2, arg0.effectFrontTf)

			return {
				tf = var2,
				config = var1
			}
		end,
		start = function(arg0)
			return
		end,
		step = function(arg0, arg1)
			local var0 = arg0.skillCtrl:getBullets()

			for iter0 = 1, #var0 do
				local var1 = var0[iter0]
				local var2 = var1.useData
				local var3 = var2.line
				local var4 = var2.camp
				local var5 = var1.tf.position
				local var6 = arg0.charCtrl:getCanHitChar(var3, var4)
				local var7 = false

				for iter1, iter2 in ipairs(var6) do
					if not var7 and iter2:inBulletBound() and iter2:checkBulletCollider(var5) then
						local var8 = var1.config.damage

						var7 = true
						var1.hit = true
						var2.target = iter2

						arg0:createDamage({
							damage = var8,
							position = var2.target:getAnimPos(),
							useData = var1.useData
						})
					end
				end
			end

			for iter3 = #arg0.effects, 1, -1 do
				local var9 = arg0.effects[iter3]

				if var9.time and var9.time > 0 then
					var9.time = var9.time - arg1

					if var9.time <= 0 then
						var9.time = 0

						setActive(var9.tf, false)

						local var10 = table.remove(arg0.effects, iter3)

						table.insert(arg0.effectPool, var10)
					end
				end
			end
		end,
		stop = function(arg0)
			return
		end,
		clear = function(arg0)
			for iter0 = #arg0.effects, 1, -1 do
				setActive(arg0.effects[iter0].tf, false)
				table.insert(arg0.effectPool, table.remove(arg0.effects, iter0))
			end
		end
	}

	var0:Ctor()

	return var0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0._event = arg3
	arg0._gameData = arg2
	arg0.asset = arg0._gameData.asset
	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 0.0333333333333333, -1)

	arg0:init()
end

function var0.init(arg0)
	arg0.charTpl = findTF(arg0._tf, "sceneContainer/scene/classes/charTpl")
	arg0.charCtrl = var1(arg0._tf, arg0.charTpl, arg0._event)
	arg0.lineCtrl = var2(arg0._tf, arg0._event)
	arg0.skillCtrl = var3(arg0._tf, arg0._event)
	arg0.enemyCtrl = var4(arg0._tf, arg0._event)
	arg0.damageCtrl = var5(arg0._tf, arg0._event)

	arg0.damageCtrl:setCharCtrl(arg0.charCtrl)
	arg0.damageCtrl:setSkillCtrl(arg0.skillCtrl)
	arg0.timer:Start()
end

function var0.onTimer(arg0)
	arg0.lineCtrl:onTimer()
end

function var0.setData(arg0, arg1)
	arg0._runningData = arg1

	local var0 = arg0._runningData.chapter
	local var1 = BeachGuardConst.chapter_data[var0]
	local var2 = BeachGuardConst.map_data[var1.map]
	local var3 = BeachGuardConst.chapater_enemy[var0]

	arg0.lineCtrl:setMapData(var2)
	arg0.enemyCtrl:setData(var3)

	if arg1.fog then
		setActive(findTF(arg0._tf, "sceneContainer/scene_front/fog"), true)
	else
		setActive(findTF(arg0._tf, "sceneContainer/scene_front/fog"), false)
	end

	local var4 = GetComponent(findTF(arg0._tf, "sceneBg/map"), typeof(Image))

	var4.sprite = BeachGuardAsset.getBeachMap(var2.pic)

	var4:SetNativeSize()
end

function var0.start(arg0)
	arg0.charCtrl:start()
	arg0.skillCtrl:start()
	arg0.enemyCtrl:start()
	arg0.damageCtrl:start()
	arg0.lineCtrl:start()
end

function var0.step(arg0)
	local var0 = arg0._runningData.deltaTime

	arg0.charCtrl:step(var0)
	arg0.skillCtrl:step(var0)
	arg0.enemyCtrl:step(var0)
	arg0.damageCtrl:step(var0)
	arg0.lineCtrl:step(var0)

	if arg0.charCtrl:getEnemyOver() then
		arg0._event:emit(BeachGuardGameView.GAME_OVER)
	elseif #arg0.charCtrl:getEnemys() == 0 and arg0.enemyCtrl:getFinishCreate() then
		arg0._event:emit(BeachGuardGameView.GAME_OVER)
	end
end

function var0.stop(arg0)
	arg0.charCtrl:stop()
	arg0.skillCtrl:stop()
	arg0.enemyCtrl:stop()
	arg0.damageCtrl:stop()
end

function var0.clear(arg0)
	arg0.charCtrl:clear()
	arg0.lineCtrl:clear()
	arg0.skillCtrl:clear()
	arg0.enemyCtrl:clear()
	arg0.damageCtrl:clear()
end

function var0.changeRecycles(arg0, arg1)
	arg0.charCtrl:changeRecycles(arg1)
end

function var0.pullChar(arg0, arg1, arg2, arg3)
	local var0 = arg0.lineCtrl:getGridByIndex(arg2, arg3)

	if var0 and var0:isEmpty() then
		local var1 = arg0.charCtrl:setGridChar(arg1, var0)

		var0:setChar(var1)

		return true
	end

	return false
end

function var0.setDrag(arg0, arg1)
	arg0.lineCtrl:setDrag(arg1)
end

function var0.useSkill(arg0, arg1)
	arg0.skillCtrl:useSkill(arg1)
end

function var0.addEnemy(arg0, arg1)
	local var0 = arg0.lineCtrl:getAbleLinePos(arg1.lines)

	arg0.charCtrl:addEnemyChar(arg1.id, var0)
end

function var0.craeteCharDamage(arg0, arg1)
	arg0.damageCtrl:craeteCharDamage(arg1)
end

function var0.removeChar(arg0, arg1)
	arg0.charCtrl:removeChar(arg1)
	arg0.lineCtrl:removeGridChar(arg1)
end

function var0.bulletDamage(arg0, arg1)
	arg0.damageCtrl:bulletDamage(arg1)
end

function var0.dispose(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

return var0
