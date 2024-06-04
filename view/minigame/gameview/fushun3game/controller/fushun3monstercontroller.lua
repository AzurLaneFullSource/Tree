local var0 = class("Fushun3MonsterController")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._tpl = arg1
	arg0._parent = arg2
	arg0._event = arg4
	arg0._sceneTf = arg3
	arg0.monsterDatas = {}

	for iter0 = 1, #Fushun3GameConst.monster_data do
		table.insert(arg0.monsterDatas, Clone(Fushun3GameConst.monster_data[iter0]))
	end

	arg0.monsters = {}
	arg0.monsterPool = {}
end

function var0.setDiff(arg0, arg1)
	return
end

function var0.start(arg0)
	arg0:clearMonster()
end

function var0.step(arg0)
	for iter0 = 1, #arg0.monsters do
		if not arg0.monsters[iter0].damage then
			arg0.monsters[iter0].rect:step()
		end
	end

	arg0:removeOutMonster()
end

function var0.removeOutMonster(arg0)
	for iter0 = #arg0.monsters, 1, -1 do
		if arg0.monsters[iter0].tf.anchoredPosition.x <= math.abs(arg0._sceneTf.anchoredPosition.x) - 1920 then
			arg0:returnMonsterToPool(table.remove(arg0.monsters, iter0))
		end
	end
end

function var0.createMonster(arg0, arg1)
	local var0 = arg0.monsterDatas[math.random(1, #arg0.monsterDatas)]
	local var1 = arg0:getOrCreateMonster(var0.id)

	if var1 then
		var1.damage = false

		setActive(var1.tf, true)

		var1.tf.position = arg1
	end
end

function var0.getOrCreateMonster(arg0, arg1)
	local var0

	for iter0 = 1, #arg0.monsterPool do
		if arg0.monsterPool[iter0].data.id == arg1 then
			var0 = table.remove(arg0.monsterPool, iter0)

			table.insert(arg0.monsters, var0)

			return var0
		end
	end

	local var1

	for iter1 = 1, #arg0.monsterDatas do
		if arg0.monsterDatas[iter1].id == arg1 then
			var1 = arg0.monsterDatas[iter1]
		end
	end

	if var1 then
		local var2 = var1.name
		local var3 = tf(instantiate(findTF(arg0._tpl, var2)))

		var3.localScale = Fushun3GameConst.game_scale_v3

		local var4 = RectCollider.New(var3, {}, arg0._event)

		var4:addScript(FuShunMonsterScript.New())

		var4:getCollisionInfo().config.moveSpeed = math.random(Fushun3GameConst.monster_speed[1], Fushun3GameConst.monster_speed[2])

		local var5 = GetComponent(findTF(var3, "anim"), typeof(Animator))

		setParent(var3, arg0._parent)

		local var6 = GetComponent(findTF(var3, "collider"), typeof(BoxCollider2D))

		var0 = {
			tf = var3,
			data = var1,
			rect = var4,
			animator = var5,
			collider = var6
		}

		GetComponent(findTF(var3, "anim"), typeof(DftAniEvent)):SetEndEvent(function()
			arg0:removeMonster(var0)
		end)
		table.insert(arg0.monsters, var0)
	end

	return var0
end

function var0.checkPlayerDamage(arg0, arg1, arg2)
	for iter0 = 1, #arg0.monsters do
		local var0 = arg0.monsters[iter0]

		if var0.tf == arg1 and var0.damage then
			arg2(true)

			return
		end
	end

	arg2(false)
end

function var0.checkMonsterDamage(arg0, arg1, arg2, arg3)
	local var0 = arg1.bounds

	for iter0 = 1, #arg0.monsters do
		local var1 = arg0.monsters[iter0]
		local var2 = var1.collider.bounds

		if not var1.damage and Fushun3GameConst.CheckBoxCollider(var0.min, var2.min, var0.size, var2.size) then
			arg0:damageMonster(var1.tf, arg3)

			if arg2 then
				arg2(true)
			end

			return
		end
	end

	if arg2 then
		arg2(false)
	end
end

function var0.damageMonster(arg0, arg1, arg2, arg3)
	for iter0 = #arg0.monsters, 1, -1 do
		if arg0.monsters[iter0].tf == arg1 then
			local var0 = arg0.monsters[iter0]

			if not var0.damage then
				var0.damage = true

				if arg2 == Fushun3GameEvent.power_damage_monster_call then
					var0.animator:SetTrigger("dmg_ex")
				elseif arg2 == Fushun3GameEvent.shot_damage_monster_call then
					var0.animator:SetTrigger("dmg_la")
				elseif arg2 == Fushun3GameEvent.kick_damage_monster_call then
					var0.animator:SetTrigger("dmg_jump")
				elseif arg2 == Fushun3GameEvent.attack_damdage_monster_call then
					var0.animator:SetTrigger("dmg_attack")
				end

				arg0._event:emit(Fushun3GameEvent.add_monster_score_call)

				if arg3 then
					arg3(true)
				end
			end

			return
		end
	end

	if arg3 then
		arg3(false)
	end
end

function var0.removeMonster(arg0, arg1)
	for iter0 = 1, #arg0.monsters do
		if arg0.monsters[iter0] == arg1 then
			arg0:returnMonsterToPool(table.remove(arg0.monsters, iter0))

			return
		end
	end
end

function var0.returnMonsterToPool(arg0, arg1)
	setActive(arg1.tf, false)
	table.insert(arg0.monsterPool, arg1)
end

function var0.clearMonster(arg0)
	for iter0 = #arg0.monsters, 1, -1 do
		arg0:returnMonsterToPool(table.remove(arg0.monsters, iter0))
	end
end

return var0
