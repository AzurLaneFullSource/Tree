local var0_0 = class("BeachGuardSceneMgr")

local function var1_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = {
		Ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._charTpl = arg1_1
			arg0_2._event = arg2_1
			arg0_2.chars = {}
			arg0_2.charPool = {}
			arg0_2.gridChars = {}
			arg0_2.enemys = {}
			arg0_2.enemysPool = {}
			arg0_2.content = findTF(arg0_2._tf, "sceneContainer/scene/content")
		end,
		changeRecycles = function(arg0_3, arg1_3)
			arg0_3.recycle = arg1_3

			for iter0_3 = #arg0_3.chars, 1, -1 do
				arg0_3.chars[iter0_3]:setRecycleFlag(arg1_3)
			end
		end,
		setGridChar = function(arg0_4, arg1_4, arg2_4)
			local var0_4 = arg2_4:getPos()
			local var1_4 = arg0_4:createChar(arg1_4)
			local var2_4 = arg0_4.content:InverseTransformPoint(var0_4.position)

			var1_4:prepareData()
			var1_4:setParent(arg0_4.content, true, var2_4)
			var1_4:setLineIndex(arg2_4:getLineIndex())
			var1_4:setGridIndex(arg2_4:getIndex())
			var1_4:setCamp(1)
			var1_4:setRaycast(true)
			table.insert(arg0_4.chars, var1_4)

			return var1_4
		end,
		createChar = function(arg0_5, arg1_5)
			local var0_5 = arg0_5:getCharFromPool(arg1_5)

			if not var0_5 then
				local var1_5 = BeachGuardConst.chars[arg1_5]

				var0_5 = BeachGuardChar.New(tf(instantiate(arg0_5._charTpl)), var1_5, arg0_5._event)
			end

			return var0_5
		end,
		getCharFromPool = function(arg0_6, arg1_6)
			for iter0_6 = #arg0_6.charPool, 1, -1 do
				if arg0_6.charPool[iter0_6]:getId() == arg1_6 then
					return table.remove(arg0_6.charPool, iter0_6)
				end
			end

			return nil
		end,
		removeChar = function(arg0_7, arg1_7)
			for iter0_7 = #arg0_7.chars, 1, -1 do
				if arg0_7.chars[iter0_7] == arg1_7 then
					local var0_7 = table.remove(arg0_7.chars, iter0_7)

					var0_7:clear()
					table.insert(arg0_7.charPool, var0_7)
				elseif arg0_7.chars[iter0_7]:getTarget() == arg1_7 then
					arg0_7.chars[iter0_7]:setTarget(nil)
				end
			end

			for iter1_7 = #arg0_7.enemys, 1, -1 do
				if arg0_7.enemys[iter1_7] == arg1_7 then
					local var1_7 = table.remove(arg0_7.enemys, iter1_7)

					var1_7:clear()
					table.insert(arg0_7.charPool, var1_7)
				elseif arg0_7.enemys[iter1_7]:getTarget() == arg1_7 then
					arg0_7.enemys[iter1_7]:setTarget(nil)
				end
			end
		end,
		clear = function(arg0_8)
			for iter0_8 = #arg0_8.chars, 1, -1 do
				local var0_8 = table.remove(arg0_8.chars, iter0_8)

				var0_8:clear()
				table.insert(arg0_8.charPool, var0_8)
			end

			for iter1_8 = #arg0_8.enemys, 1, -1 do
				local var1_8 = table.remove(arg0_8.enemys, iter1_8)

				var1_8:clear()
				table.insert(arg0_8.charPool, var1_8)
			end
		end,
		start = function(arg0_9)
			for iter0_9 = #arg0_9.chars, 1, -1 do
				arg0_9.chars[iter0_9]:start()
			end

			arg0_9.recycle = false
		end,
		step = function(arg0_10, arg1_10)
			for iter0_10 = #arg0_10.chars, 1, -1 do
				arg0_10.chars[iter0_10]:step(arg1_10)
			end

			for iter1_10 = #arg0_10.enemys, 1, -1 do
				arg0_10.enemys[iter1_10]:step(arg1_10)
			end

			arg0_10.enemyOver = false

			for iter2_10 = #arg0_10.enemys, 1, -1 do
				local var0_10 = arg0_10.enemys[iter2_10]

				if not var0_10:getTarget() then
					local var1_10 = var0_10:getLineIndex()
					local var2_10 = var0_10:getPointWorld()
					local var3_10 = var0_10:getPos()
					local var4_10 = arg0_10:getCharLine(var1_10)
					local var5_10 = false

					for iter3_10, iter4_10 in ipairs(var4_10) do
						if iter4_10:checkCollider(var2_10, var3_10) and (not var5_10 or true) then
							var5_10 = true

							var0_10:setTarget(iter4_10)
						end
					end
				end

				if var0_10:getPos().x < BeachGuardConst.enemy_over_width then
					arg0_10.enemyOver = true
				end
			end

			for iter5_10 = 1, #arg0_10.chars do
				local var6_10 = arg0_10.chars[iter5_10]
				local var7_10 = var6_10:getSkillDistance() * BeachGuardConst.part_width
				local var8_10 = arg0_10:getCanHitChar(var6_10:getLineIndex(), var6_10:getCamp())

				for iter6_10, iter7_10 in ipairs(var8_10) do
					local var9_10 = iter7_10:getPos().x - var6_10:getPos().x

					if var9_10 > 0 and var9_10 < var7_10 then
						var6_10:setTarget(iter7_10)
					end
				end
			end

			arg0_10:sortChar()
		end,
		stop = function(arg0_11)
			for iter0_11 = #arg0_11.chars, 1, -1 do
				arg0_11.chars[iter0_11]:stop()
			end
		end,
		getLineCampChars = function(arg0_12, arg1_12, arg2_12)
			local var0_12 = {}
			local var1_12 = {}

			if arg2_12 == 1 then
				var1_12 = arg0_12.chars
			elseif arg2_12 == 2 then
				var1_12 = arg0_12.enemys
			end

			for iter0_12 = 1, #var1_12 do
				local var2_12 = var1_12[iter0_12]

				if table.contains(arg1_12, var2_12:getLineIndex()) then
					table.insert(var0_12, var2_12)
				end
			end

			return var0_12
		end,
		getCharByCamp = function(arg0_13, arg1_13)
			local var0_13 = {}

			if arg1_13 == 1 then
				var0_13 = arg0_13.chars
			elseif arg1_13 == 2 then
				var0_13 = arg0_13.enemys
			end

			return var0_13
		end,
		getEnemyOver = function(arg0_14)
			return arg0_14.enemyOver
		end,
		getCanHitChar = function(arg0_15, arg1_15, arg2_15)
			local var0_15 = {}
			local var1_15 = {}

			if arg2_15 == 1 then
				var1_15 = arg0_15.enemys
			elseif arg2_15 == 2 then
				var1_15 = arg0_15.chars
			end

			for iter0_15 = 1, #var1_15 do
				local var2_15 = var1_15[iter0_15]

				if var2_15:getLineIndex() == arg1_15 and var2_15:inBulletBound() then
					table.insert(var0_15, var2_15)
				end
			end

			return var0_15
		end,
		getChars = function(arg0_16)
			return arg0_16.chars
		end,
		getEnemys = function(arg0_17)
			return arg0_17.enemys
		end,
		getCharLine = function(arg0_18, arg1_18)
			local var0_18 = {}

			for iter0_18 = 1, #arg0_18.chars do
				local var1_18 = arg0_18.chars[iter0_18]

				if var1_18:getLineIndex() == arg1_18 then
					table.insert(var0_18, var1_18)
				end
			end

			return var0_18
		end,
		addEnemyChar = function(arg0_19, arg1_19, arg2_19)
			local var0_19 = arg1_19
			local var1_19 = arg0_19:createChar(var0_19)

			var1_19:prepareData()
			var1_19:setLineIndex(arg2_19.index)

			local var2_19 = arg0_19.content:InverseTransformPoint(arg2_19.position)
			local var3_19 = math.random(BeachGuardConst.enemy_pos[1], BeachGuardConst.enemy_pos[2])

			var1_19:setParent(arg0_19.content, false, Vector2(var3_19 + var2_19.x, var2_19.y + BeachGuardConst.enemy_offset_y))
			var1_19:setCamp(2)
			var1_19:setRaycast(false)
			table.insert(arg0_19.enemys, var1_19)
		end,
		sortChar = function(arg0_20)
			local var0_20 = #arg0_20.chars + #arg0_20.enemys

			if not arg0_20.sorts or #arg0_20.sorts ~= var0_20 then
				arg0_20.sorts = {}

				for iter0_20 = 1, #arg0_20.chars do
					table.insert(arg0_20.sorts, arg0_20.chars[iter0_20])
				end

				for iter1_20 = 1, #arg0_20.enemys do
					table.insert(arg0_20.sorts, arg0_20.enemys[iter1_20])
				end

				table.sort(arg0_20.sorts, function(arg0_21, arg1_21)
					local var0_21 = arg0_21:getPos()
					local var1_21 = arg1_21:getPos()

					if var0_21.y > var1_21.y then
						return true
					elseif var0_21.y < var1_21.y then
						return false
					end

					if var0_21.x > var1_21.x then
						return true
					elseif var0_21.x < var1_21.x then
						return false
					end
				end)

				for iter2_20 = 1, #arg0_20.sorts do
					arg0_20.sorts[iter2_20]:SetSiblingIndex(iter2_20)
				end
			end
		end
	}

	var0_1:Ctor()

	return var0_1
end

local function var2_0(arg0_22, arg1_22)
	local var0_22 = {
		Ctor = function(arg0_23)
			arg0_23._tf = arg0_22
			arg0_23._event = arg1_22
			arg0_23.lineTpl = findTF(arg0_23._tf, "sceneContainer/scene/classes/lineTpl")
			arg0_23.gridTpl = findTF(arg0_23._tf, "sceneContainer/scene/classes/gridTpl")
			arg0_23.lines = {}
			arg0_23.content = findTF(arg0_23._tf, "sceneContainer/scene/content")

			for iter0_23 = 1, BeachGuardConst.line_num do
				local var0_23 = findTF(arg0_23._tf, "sceneContainer/scene/linePos/" .. iter0_23)
				local var1_23 = tf(instantiate(arg0_23.lineTpl))

				var1_23.anchoredPosition = Vector2(0, 0)

				setParent(var1_23, var0_23)

				local var2_23 = BeachGuardLine.New(var1_23, arg0_23.gridTpl, arg0_23._event)

				var2_23:setIndex(iter0_23)
				table.insert(arg0_23.lines, var2_23)
			end
		end,
		setMapData = function(arg0_24, arg1_24)
			local var0_24 = arg1_24.line

			arg0_24.activeLines = {}

			for iter0_24 = 1, #arg0_24.lines do
				local var1_24 = arg0_24.lines[iter0_24]

				if table.contains(var0_24, var1_24:getIndex()) then
					var1_24:active(true)
					table.insert(arg0_24.activeLines, var1_24)
				else
					var1_24:active(false)
				end
			end
		end,
		getGridByIndex = function(arg0_25, arg1_25, arg2_25)
			for iter0_25 = 1, #arg0_25.activeLines do
				local var0_25 = arg0_25.activeLines[iter0_25]

				if var0_25:getIndex() == arg1_25 then
					return var0_25:getGridByIndex(arg2_25)
				end
			end

			return nil
		end,
		setDrag = function(arg0_26, arg1_26)
			arg0_26.dragData = arg1_26
		end,
		start = function(arg0_27)
			for iter0_27 = 1, #arg0_27.lines do
				local var0_27 = arg0_27.lines[iter0_27]:start()
			end
		end,
		step = function(arg0_28, arg1_28)
			for iter0_28 = 1, #arg0_28.lines do
				local var0_28 = arg0_28.lines[iter0_28]:step(arg1_28)
			end
		end,
		clear = function(arg0_29)
			arg0_29:clearPre()

			for iter0_29 = 1, #arg0_29.lines do
				arg0_29.lines[iter0_29]:clear()
			end
		end,
		onTimer = function(arg0_30)
			if not arg0_30.dragData then
				return
			end

			if arg0_30.dragData.flag ~= true or not arg0_30.dragData.pos then
				if arg0_30.preCharGrid then
					arg0_30._event:emit(BeachGuardGameView.PULL_CHAR, {
						card_id = arg0_30.preCardID,
						line_index = arg0_30.preCharGrid:getLineIndex(),
						grid_index = arg0_30.preCharGrid:getIndex()
					})
				end

				arg0_30:clearPre()

				return
			end

			local var0_30 = arg0_30.dragData.pos
			local var1_30 = arg0_30:getGridByWorld(var0_30)

			if var1_30 and var1_30:isEmpty() then
				local var2_30 = arg0_30.dragData.config
				local var3_30 = var2_30.char_id
				local var4_30 = var2_30.id

				if arg0_30.preCharGrid == var1_30 and arg0_30.preCardID == var4_30 then
					return
				end

				arg0_30:clearPre()

				arg0_30.preCharGrid = var1_30
				arg0_30.preCardID = var4_30

				arg0_30.preCharGrid:prechar(var3_30)

				local var5_30 = arg0_30.preCharGrid:getLineIndex()
				local var6_30 = arg0_30.preCharGrid:getIndex()

				if var5_30 and var6_30 then
					local var7_30 = BeachGuardConst.chars[var3_30].distance

					for iter0_30 = 1, var7_30 do
						local var8_30 = arg0_30:getGridByIndex(var5_30, var6_30 + iter0_30)

						if var8_30 then
							var8_30:preDistance()
							table.insert(arg0_30.preDistanceGrids, var8_30)
						end
					end
				end
			else
				arg0_30:clearPre()
			end
		end,
		clearPre = function(arg0_31)
			if arg0_31.preCharGrid then
				arg0_31.preCharGrid:unPreChar()

				arg0_31.preCharGrid = nil
			end

			if arg0_31.preDistanceGrids and #arg0_31.preDistanceGrids > 0 then
				for iter0_31 = 1, #arg0_31.preDistanceGrids do
					arg0_31.preDistanceGrids[iter0_31]:unPreDistance()
				end
			end

			arg0_31.preDistanceGrids = {}
		end,
		removeGridChar = function(arg0_32, arg1_32)
			local var0_32 = arg0_32:getGridByChar(arg1_32)

			if var0_32 then
				var0_32:removeChar()

				return true
			end
		end,
		getGridByWorld = function(arg0_33, arg1_33)
			for iter0_33 = 1, #arg0_33.activeLines do
				local var0_33 = arg0_33.activeLines[iter0_33]:getGridWorld(arg1_33)

				if var0_33 then
					return var0_33
				end
			end

			return nil
		end,
		getGridByChar = function(arg0_34, arg1_34)
			for iter0_34 = 1, #arg0_34.lines do
				local var0_34 = arg0_34.lines[iter0_34]:getGrids()

				for iter1_34, iter2_34 in ipairs(var0_34) do
					if iter2_34:getChar() == arg1_34 then
						return iter2_34
					end
				end
			end

			return nil
		end,
		getAbleLinePos = function(arg0_35, arg1_35)
			local var0_35 = {}

			for iter0_35 = 1, #arg0_35.activeLines do
				local var1_35 = arg0_35.activeLines[iter0_35]:getIndex()

				if table.contains(arg1_35, var1_35) then
					table.insert(var0_35, {
						position = arg0_35.activeLines[iter0_35]:getPosition(),
						index = var1_35
					})
				end
			end

			return var0_35[math.random(1, #var0_35)]
		end
	}

	var0_22:Ctor()

	return var0_22
end

local function var3_0(arg0_36, arg1_36)
	local var0_36 = {
		Ctor = function(arg0_37)
			arg0_37._tf = arg0_36
			arg0_37._event = arg1_36
			arg0_37.content = findTF(arg0_37._tf, "sceneContainer/scene/content")
			arg0_37.bullets = {}
			arg0_37.bulletPool = {}
		end,
		useSkill = function(arg0_38, arg1_38)
			local var0_38 = arg1_38.skill

			if var0_38.type == BeachGuardConst.skill_craft then
				arg0_38._event:emit(BeachGuardGameView.ADD_CRAFT, {
					num = var0_38.num
				})
			elseif var0_38.type == BeachGuardConst.skill_bullet then
				local var1_38 = var0_38.bullet_id

				for iter0_38, iter1_38 in ipairs(var1_38) do
					arg0_38:pullBullet(iter1_38, arg1_38)
				end
			elseif var0_38.type == BeachGuardConst.skill_melee then
				local var2_38 = arg1_38.damage
				local var3_38 = arg1_38.target
				local var4_38 = arg1_38.position

				arg0_38._event:emit(BeachGuardGameView.CREATE_CHAR_DAMAGE, {
					damage = var2_38,
					position = var4_38,
					target = var3_38,
					useData = arg1_38
				})
			end
		end,
		pullBullet = function(arg0_39, arg1_39, arg2_39)
			local var0_39 = arg0_39:getOrCreateBullet(arg1_39)
			local var1_39 = arg2_39.position
			local var2_39 = arg2_39.distanceVec
			local var3_39 = var0_39.config.offset

			var0_39.tf.anchoredPosition = arg0_39.content:InverseTransformPoint(var1_39)

			if var3_39 then
				var0_39.tf.anchoredPosition = Vector2(var0_39.tf.anchoredPosition.x + var3_39.x, var0_39.tf.anchoredPosition.y + var3_39.y)
			end

			setActive(var0_39.tf, true)

			var0_39.distanceVec = var2_39
			var0_39.speed = Vector2(var0_39.config.speed[1], var0_39.config.speed[2])
			var0_39.direct = arg2_39.direct
			var0_39.hit = false
			var0_39.useData = arg2_39

			if var0_39.config.point_able then
				var0_39.life = nil
			elseif var0_39.config.speed_high and var0_39.config.speed_high ~= 0 then
				local var4_39 = arg2_39.target:getPos()
				local var5_39 = math.random(-10, 5)

				var4_39.x = var4_39.x + 5 - math.random() * 15

				local var6_39 = arg2_39.useChar:getPos()

				if var4_39 and var6_39 then
					var0_39.life = math.abs(var4_39.x - var6_39.x) / math.abs(var0_39.speed.x)
				else
					var0_39.life = math.abs(var0_39.distanceVec.x) / math.abs(var0_39.speed.x)
				end
			else
				var0_39.life = math.abs(var0_39.distanceVec.x) / math.abs(var0_39.speed.x)
			end

			var0_39.gravity = 0

			if var0_39.config.speed_high and var0_39.config.speed_high ~= 0 then
				local var7_39 = -(var0_39.config.speed_high * 2) / math.pow(var0_39.life / 2, 2)

				var0_39.speed.y = math.abs(var7_39) * (var0_39.life / 2)
				var0_39.gravity = var7_39
			end

			table.insert(arg0_39.bullets, var0_39)
		end,
		getBullets = function(arg0_40)
			return arg0_40.bullets
		end,
		getOrCreateBullet = function(arg0_41, arg1_41)
			local var0_41 = arg0_41:getBulletFromPool(arg1_41)

			if not var0_41 then
				local var1_41 = BeachGuardConst.bullet[arg1_41]
				local var2_41 = BeachGuardAsset.getBullet(var1_41.name)

				setParent(var2_41, arg0_41.content)

				var0_41 = {
					tf = var2_41,
					config = var1_41
				}
			end

			return var0_41
		end,
		getBulletFromPool = function(arg0_42, arg1_42)
			for iter0_42 = #arg0_42.bulletPool, 1, -1 do
				if arg0_42.bulletPool[iter0_42].config.id == arg1_42 then
					return table.remove(arg0_42.bulletPool, iter0_42)
				end
			end

			return nil
		end,
		finishBullet = function(arg0_43, arg1_43)
			local var0_43 = arg1_43.config.damage

			setActive(arg1_43.tf, false)

			local var1_43 = arg1_43.tf.anchoredPosition
		end,
		start = function(arg0_44)
			return
		end,
		step = function(arg0_45, arg1_45)
			for iter0_45 = #arg0_45.bullets, 1, -1 do
				local var0_45 = arg0_45.bullets[iter0_45]
				local var1_45 = var0_45.speed
				local var2_45 = var0_45.gravity
				local var3_45 = var0_45.direct

				var0_45.tf.anchoredPosition = Vector2(var0_45.tf.anchoredPosition.x + var1_45.x * arg1_45 * var3_45, var0_45.tf.anchoredPosition.y + var1_45.y * arg1_45)
				var0_45.speed.y = var0_45.speed.y + var0_45.gravity * arg1_45

				if var0_45.life then
					var0_45.life = var0_45.life - arg1_45

					if var0_45.life <= 0 then
						if var0_45.config.speed_high and var0_45.config.speed_high ~= 0 and not var0_45.hit then
							local var4_45 = var0_45.config.damage

							var0_45.useData.target = nil

							arg0_45._event:emit(BeachGuardGameView.BULLET_DAMAGE, {
								damage = var4_45,
								position = var0_45.tf.position,
								useData = var0_45.useData
							})
						end

						local var5_45 = table.remove(arg0_45.bullets, iter0_45)

						arg0_45:finishBullet(var5_45)
						table.insert(arg0_45.bulletPool, var5_45)
					elseif var0_45.hit then
						local var6_45 = table.remove(arg0_45.bullets, iter0_45)

						arg0_45:finishBullet(var6_45)
						table.insert(arg0_45.bulletPool, var6_45)
					end
				end
			end
		end,
		stop = function(arg0_46)
			return
		end,
		clear = function(arg0_47)
			for iter0_47 = #arg0_47.bullets, 1, -1 do
				local var0_47 = table.remove(arg0_47.bullets, iter0_47)

				setActive(var0_47.tf, false)

				var0_47.distanceVec = nil

				table.insert(arg0_47.bulletPool, var0_47)
			end
		end
	}

	var0_36:Ctor()

	return var0_36
end

local function var4_0(arg0_48, arg1_48)
	local var0_48 = {
		Ctor = function(arg0_49)
			arg0_49._tf = arg0_48
			arg0_49._event = arg1_48
		end,
		setData = function(arg0_50, arg1_50)
			arg0_50._data = arg1_50
			arg0_50._chapterId = arg0_50._data.id
		end,
		start = function(arg0_51)
			arg0_51:clear()

			arg0_51._chapterDatas = Clone(arg0_51._data.data)
		end,
		step = function(arg0_52, arg1_52)
			arg0_52._overTime = arg0_52._overTime + arg1_52

			for iter0_52 = #arg0_52._chapterDatas, 1, -1 do
				if arg0_52._chapterDatas[iter0_52].time < arg0_52._overTime then
					local var0_52 = arg0_52:createData(table.remove(arg0_52._chapterDatas, iter0_52))

					table.insert(arg0_52.enemyDatas, var0_52)
				end
			end

			for iter1_52 = #arg0_52.enemyDatas, 1, -1 do
				local var1_52 = arg0_52.enemyDatas[iter1_52]

				if var1_52.loop then
					var1_52.stepTime = var1_52.stepTime - arg1_52

					if var1_52.stepTime <= 0 then
						local var2_52 = var1_52.step

						var1_52.stepTime = math.random() * (var2_52[2] - var2_52[1]) + var2_52[1]

						arg0_52:addEnemyData(var1_52)
					end

					if arg0_52._overTime > var1_52.stop then
						table.remove(arg0_52.enemyDatas, iter1_52)
					end
				else
					arg0_52:addEnemyData(var1_52)
					table.remove(arg0_52.enemyDatas, iter1_52)
				end
			end

			if not arg0_52.addEnemyTime then
				arg0_52.addEnemyTime = 1
			end

			arg0_52.addEnemyTime = arg0_52.addEnemyTime - arg1_52

			if #arg0_52.enemyList > 0 and arg0_52.addEnemyTime <= 0 then
				local var3_52 = table.remove(arg0_52.enemyList, #arg0_52.enemyList)

				arg0_52._event:emit(BeachGuardGameView.ADD_ENEMY, var3_52)
			end

			if #arg0_52.enemyDatas == 0 and #arg0_52._chapterDatas == 0 and #arg0_52.enemyList == 0 then
				arg0_52.finishCreate = true
			end
		end,
		getFinishCreate = function(arg0_53)
			return arg0_53.finishCreate
		end,
		createData = function(arg0_54, arg1_54)
			local var0_54 = {}
			local var1_54 = arg1_54.create
			local var2_54 = arg1_54.time
			local var3_54 = arg1_54.stop
			local var4_54 = arg1_54.step
			local var5_54 = arg1_54.comming

			if var4_54 then
				var0_54.loop = true
				var0_54.stepTime = 0
			else
				var0_54.loop = false
			end

			var0_54.create = var1_54
			var0_54.time = var2_54
			var0_54.stop = var3_54
			var0_54.step = var4_54
			var0_54.comming = var5_54

			return var0_54
		end,
		addEnemyData = function(arg0_55, arg1_55)
			local var0_55 = arg1_55.create

			if arg1_55.comming or false then
				arg1_55.comming = false

				arg0_55._event:emit(BeachGuardGameView.ENEMY_COMMING)
			end

			local var1_55 = BeachGuardConst.create_enemy[var0_55]

			for iter0_55 = 1, var1_55.num do
				local var2_55 = var1_55.enemy[math.random(1, #var1_55.enemy)]
				local var3_55 = var1_55.line

				table.insert(arg0_55.enemyList, {
					id = var2_55,
					lines = var3_55
				})
			end
		end,
		stop = function(arg0_56)
			return
		end,
		clear = function(arg0_57)
			arg0_57._overTime = 0
			arg0_57._chapterDatas = {}
			arg0_57.enemyDatas = {}
			arg0_57.enemyList = {}
			arg0_57.finishCreate = false
		end
	}

	var0_48:Ctor()

	return var0_48
end

local function var5_0(arg0_58, arg1_58)
	local var0_58 = {
		Ctor = function(arg0_59)
			arg0_59._tf = arg0_58
			arg0_59._event = arg1_58
			arg0_59.effectBackTf = findTF(arg0_59._tf, "sceneContainer/scene/effect_back")
			arg0_59.effectFrontTf = findTF(arg0_59._tf, "sceneContainer/scene/effect_front")
			arg0_59.content = findTF(arg0_59._tf, "sceneContainer/scene/content")
			arg0_59.effects = {}
			arg0_59.effectPool = {}
		end,
		setCharCtrl = function(arg0_60, arg1_60)
			arg0_60.charCtrl = arg1_60
		end,
		setSkillCtrl = function(arg0_61, arg1_61)
			arg0_61.skillCtrl = arg1_61
		end,
		craeteCharDamage = function(arg0_62, arg1_62)
			arg0_62:createDamage(arg1_62)
		end,
		bulletDamage = function(arg0_63, arg1_63)
			arg0_63:createDamage(arg1_63)
		end,
		createDamage = function(arg0_64, arg1_64)
			local var0_64 = arg1_64.damage
			local var1_64 = arg1_64.position
			local var2_64 = arg1_64.useData
			local var3_64 = var2_64.target
			local var4_64 = var2_64.line
			local var5_64 = var2_64.camp

			if not var0_64 then
				-- block empty
			end

			local var6_64 = BeachGuardConst.damage[var0_64]

			if var3_64 then
				local var7_64 = var2_64.atkRate or 1

				var3_64:damage(var6_64.damage * var7_64)
			end

			if var6_64.type == BeachGuardConst.bullet_type_range then
				local var8_64 = var6_64.config
				local var9_64 = var8_64.next
				local var10_64 = var8_64.range
				local var11_64 = var5_64 == 1 and 2 or 1
				local var12_64 = arg0_64.charCtrl:getLineCampChars({
					var4_64 + 1,
					var4_64 - 1,
					var4_64
				}, var11_64)
				local var13_64

				if var2_64.target then
					var13_64 = var2_64.target:getPos()
				else
					var13_64 = arg0_64.effectFrontTf:InverseTransformPoint(var1_64)
				end

				if var12_64 and #var12_64 > 0 then
					local var14_64 = var10_64 * BeachGuardConst.part_width

					for iter0_64 = 1, #var12_64 do
						local var15_64 = var12_64[iter0_64]

						if (not var2_64.target or var2_64.target ~= var15_64) and var14_64 > math.abs(var13_64.x - var15_64:getPos().x) then
							local var16_64 = var15_64:getWorldPos()
							local var17_64 = Clone(var2_64)

							var17_64.target = var15_64

							arg0_64:createDamage({
								damage = var8_64.next,
								position = var16_64,
								useData = var17_64
							})
						end
					end
				end
			elseif var6_64.type == BeachGuardConst.bullet_type_disperse then
				local var18_64 = var6_64.config
				local var19_64 = var18_64.up
				local var20_64 = var18_64.down
				local var21_64 = var5_64 == 1 and 2 or 1

				arg0_64:addDamageByDisperse({
					var4_64 - 1
				}, var18_64.range, var21_64, var19_64, var2_64)
				arg0_64:addDamageByDisperse({
					var4_64 + 1
				}, var18_64.range, var21_64, var20_64, var2_64)
			end

			if var6_64.buff and #var6_64.buff > 0 then
				for iter1_64 = 1, #var6_64.buff do
					local var22_64 = var6_64.buff[iter1_64]
					local var23_64 = BeachGuardConst.buff[var22_64]
					local var24_64 = var23_64.type
					local var25_64 = var23_64.trigger
					local var26_64 = var23_64.bound
					local var27_64 = var2_64.useChar
					local var28_64 = var2_64.target

					if var25_64 == BeachGuardConst.buff_trigger_other then
						var28_64:addBuff(var23_64)
					elseif var25_64 == BeachGuardConst.buff_trigger_self then
						var27_64:addBuff(var23_64)

						if var26_64 and var26_64 ~= nil then
							local var29_64 = var2_64.useChar:getCamp()
							local var30_64 = var2_64.useChar:getLineIndex()
							local var31_64 = var2_64.useChar:getGridIndex()

							if var30_64 and var31_64 then
								local var32_64 = arg0_64.charCtrl:getCharByCamp(var29_64)

								for iter2_64, iter3_64 in ipairs(var32_64) do
									if iter3_64 ~= var27_64 then
										local var33_64 = iter3_64:getGridIndex()
										local var34_64 = iter3_64:getLineIndex()

										if math.abs(var33_64 - var31_64) <= var26_64[1] and math.abs(var34_64 - var30_64) <= var26_64[2] then
											iter3_64:addBuff(var23_64)
										end
									end
								end
							end
						end
					end
				end
			end

			if var6_64.effect and #var6_64.effect > 0 then
				arg0_64:createEffect(var6_64.effect, var1_64)
			end
		end,
		addDamageByDisperse = function(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65, arg5_65)
			local var0_65 = arg0_65.charCtrl:getLineCampChars(arg1_65, arg3_65)

			if var0_65 and #var0_65 > 0 then
				local var1_65 = arg2_65 * BeachGuardConst.part_width
				local var2_65 = arg5_65.target:getPos()

				for iter0_65 = 1, #var0_65 do
					local var3_65 = var0_65[iter0_65]
					local var4_65 = var3_65:getPos()

					if var1_65 > math.abs(var2_65.x - var4_65.x) then
						local var5_65 = var3_65:getWorldPos()
						local var6_65 = Clone(arg5_65)

						var6_65.target = var3_65

						arg0_65:createDamage({
							damage = arg4_65,
							position = var5_65,
							useData = var6_65
						})
					end
				end
			end
		end,
		createEffect = function(arg0_66, arg1_66, arg2_66)
			local var0_66 = arg0_66:getEffect(arg1_66[1])

			if not var0_66 then
				-- block empty
			end

			if not var0_66 then
				return
			end

			var0_66.tf.anchoredPosition = arg0_66.effectFrontTf:InverseTransformPoint(arg2_66)

			setActive(var0_66.tf, true)

			var0_66.time = var0_66.config.time

			table.insert(arg0_66.effects, var0_66)
		end,
		getEffect = function(arg0_67, arg1_67)
			local var0_67

			if #arg0_67.effectPool > 0 then
				for iter0_67 = #arg0_67.effectPool, 1, -1 do
					if arg0_67.effectPool[iter0_67].config.id == arg1_67 then
						return (table.remove(arg0_67.effectPool, iter0_67))
					end
				end
			end

			local var1_67 = BeachGuardConst.effect[arg1_67]
			local var2_67 = BeachGuardAsset.getEffect(var1_67.name)

			setParent(var2_67, arg0_67.effectFrontTf)

			return {
				tf = var2_67,
				config = var1_67
			}
		end,
		start = function(arg0_68)
			return
		end,
		step = function(arg0_69, arg1_69)
			local var0_69 = arg0_69.skillCtrl:getBullets()

			for iter0_69 = 1, #var0_69 do
				local var1_69 = var0_69[iter0_69]
				local var2_69 = var1_69.useData
				local var3_69 = var2_69.line
				local var4_69 = var2_69.camp
				local var5_69 = var1_69.tf.position
				local var6_69 = arg0_69.charCtrl:getCanHitChar(var3_69, var4_69)
				local var7_69 = false

				for iter1_69, iter2_69 in ipairs(var6_69) do
					if not var7_69 and iter2_69:inBulletBound() and iter2_69:checkBulletCollider(var5_69) then
						local var8_69 = var1_69.config.damage

						var7_69 = true
						var1_69.hit = true
						var2_69.target = iter2_69

						arg0_69:createDamage({
							damage = var8_69,
							position = var2_69.target:getAnimPos(),
							useData = var1_69.useData
						})
					end
				end
			end

			for iter3_69 = #arg0_69.effects, 1, -1 do
				local var9_69 = arg0_69.effects[iter3_69]

				if var9_69.time and var9_69.time > 0 then
					var9_69.time = var9_69.time - arg1_69

					if var9_69.time <= 0 then
						var9_69.time = 0

						setActive(var9_69.tf, false)

						local var10_69 = table.remove(arg0_69.effects, iter3_69)

						table.insert(arg0_69.effectPool, var10_69)
					end
				end
			end
		end,
		stop = function(arg0_70)
			return
		end,
		clear = function(arg0_71)
			for iter0_71 = #arg0_71.effects, 1, -1 do
				setActive(arg0_71.effects[iter0_71].tf, false)
				table.insert(arg0_71.effectPool, table.remove(arg0_71.effects, iter0_71))
			end
		end
	}

	var0_58:Ctor()

	return var0_58
end

function var0_0.Ctor(arg0_72, arg1_72, arg2_72, arg3_72)
	arg0_72._tf = arg1_72
	arg0_72._event = arg3_72
	arg0_72._gameData = arg2_72
	arg0_72.asset = arg0_72._gameData.asset
	arg0_72.timer = Timer.New(function()
		arg0_72:onTimer()
	end, 0.0333333333333333, -1)

	arg0_72:init()
end

function var0_0.init(arg0_74)
	arg0_74.charTpl = findTF(arg0_74._tf, "sceneContainer/scene/classes/charTpl")
	arg0_74.charCtrl = var1_0(arg0_74._tf, arg0_74.charTpl, arg0_74._event)
	arg0_74.lineCtrl = var2_0(arg0_74._tf, arg0_74._event)
	arg0_74.skillCtrl = var3_0(arg0_74._tf, arg0_74._event)
	arg0_74.enemyCtrl = var4_0(arg0_74._tf, arg0_74._event)
	arg0_74.damageCtrl = var5_0(arg0_74._tf, arg0_74._event)

	arg0_74.damageCtrl:setCharCtrl(arg0_74.charCtrl)
	arg0_74.damageCtrl:setSkillCtrl(arg0_74.skillCtrl)
	arg0_74.timer:Start()
end

function var0_0.onTimer(arg0_75)
	arg0_75.lineCtrl:onTimer()
end

function var0_0.setData(arg0_76, arg1_76)
	arg0_76._runningData = arg1_76

	local var0_76 = arg0_76._runningData.chapter
	local var1_76 = BeachGuardConst.chapter_data[var0_76]
	local var2_76 = BeachGuardConst.map_data[var1_76.map]
	local var3_76 = BeachGuardConst.chapater_enemy[var0_76]

	arg0_76.lineCtrl:setMapData(var2_76)
	arg0_76.enemyCtrl:setData(var3_76)

	if arg1_76.fog then
		setActive(findTF(arg0_76._tf, "sceneContainer/scene_front/fog"), true)
	else
		setActive(findTF(arg0_76._tf, "sceneContainer/scene_front/fog"), false)
	end

	local var4_76 = GetComponent(findTF(arg0_76._tf, "sceneBg/map"), typeof(Image))

	var4_76.sprite = BeachGuardAsset.getBeachMap(var2_76.pic)

	var4_76:SetNativeSize()
end

function var0_0.start(arg0_77)
	arg0_77.charCtrl:start()
	arg0_77.skillCtrl:start()
	arg0_77.enemyCtrl:start()
	arg0_77.damageCtrl:start()
	arg0_77.lineCtrl:start()
end

function var0_0.step(arg0_78)
	local var0_78 = arg0_78._runningData.deltaTime

	arg0_78.charCtrl:step(var0_78)
	arg0_78.skillCtrl:step(var0_78)
	arg0_78.enemyCtrl:step(var0_78)
	arg0_78.damageCtrl:step(var0_78)
	arg0_78.lineCtrl:step(var0_78)

	if arg0_78.charCtrl:getEnemyOver() then
		arg0_78._event:emit(BeachGuardGameView.GAME_OVER)
	elseif #arg0_78.charCtrl:getEnemys() == 0 and arg0_78.enemyCtrl:getFinishCreate() then
		arg0_78._event:emit(BeachGuardGameView.GAME_OVER)
	end
end

function var0_0.stop(arg0_79)
	arg0_79.charCtrl:stop()
	arg0_79.skillCtrl:stop()
	arg0_79.enemyCtrl:stop()
	arg0_79.damageCtrl:stop()
end

function var0_0.clear(arg0_80)
	arg0_80.charCtrl:clear()
	arg0_80.lineCtrl:clear()
	arg0_80.skillCtrl:clear()
	arg0_80.enemyCtrl:clear()
	arg0_80.damageCtrl:clear()
end

function var0_0.changeRecycles(arg0_81, arg1_81)
	arg0_81.charCtrl:changeRecycles(arg1_81)
end

function var0_0.pullChar(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = arg0_82.lineCtrl:getGridByIndex(arg2_82, arg3_82)

	if var0_82 and var0_82:isEmpty() then
		local var1_82 = arg0_82.charCtrl:setGridChar(arg1_82, var0_82)

		var0_82:setChar(var1_82)

		return true
	end

	return false
end

function var0_0.setDrag(arg0_83, arg1_83)
	arg0_83.lineCtrl:setDrag(arg1_83)
end

function var0_0.useSkill(arg0_84, arg1_84)
	arg0_84.skillCtrl:useSkill(arg1_84)
end

function var0_0.addEnemy(arg0_85, arg1_85)
	local var0_85 = arg0_85.lineCtrl:getAbleLinePos(arg1_85.lines)

	arg0_85.charCtrl:addEnemyChar(arg1_85.id, var0_85)
end

function var0_0.craeteCharDamage(arg0_86, arg1_86)
	arg0_86.damageCtrl:craeteCharDamage(arg1_86)
end

function var0_0.removeChar(arg0_87, arg1_87)
	arg0_87.charCtrl:removeChar(arg1_87)
	arg0_87.lineCtrl:removeGridChar(arg1_87)
end

function var0_0.bulletDamage(arg0_88, arg1_88)
	arg0_88.damageCtrl:bulletDamage(arg1_88)
end

function var0_0.dispose(arg0_89)
	if arg0_89.timer then
		arg0_89.timer:Stop()

		arg0_89.timer = nil
	end
end

return var0_0
