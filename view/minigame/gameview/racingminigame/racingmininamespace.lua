local var0 = {}
local var1 = {
	function()
		local var0 = class("Object")

		var0.colliderSize = nil

		function var0.Ctor(arg0, arg1, arg2, arg3)
			arg0.rt = arg1
			arg0.pos = arg2

			setAnchoredPosition(arg0.rt, arg0.pos)

			arg0.controller = arg3
			arg0.isTriggered = false

			arg0:Show("base")
		end

		function var0.UpdatePos(arg0, arg1)
			arg0.pos = arg0.pos + arg1

			setAnchoredPosition(arg0.rt, arg0.pos)
		end

		function var0.Show(arg0, arg1)
			arg0.state = arg1

			setActive(arg0.rt, true)
		end

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			arg0:TriggerEffect(arg1)
		end

		function var0.TriggerEffect(arg0, arg1)
			arg1:TriggerEffect(arg0)
		end

		function var0.Clear(arg0)
			table.removebyvalue(arg0.controller.queue, arg0)
			Destroy(arg0.rt)
		end

		return var0
	end,
	function()
		return (class("StartMark", var0.Object))
	end,
	function()
		local var0 = class("Mire", var0.Object)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			if arg1.invincibleTime then
				-- block empty
			else
				arg0:TriggerEffect(arg1)
			end
		end

		return var0
	end,
	function()
		local var0 = class("SpeedBumps", var0.Object)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			if arg1.invincibleTime then
				-- block empty
			else
				arg0:TriggerEffect(arg1)
			end
		end

		return var0
	end,
	function()
		local var0 = class("Obstacle", var0.Object)

		var0.actionDic = {}

		function var0.Ctor(arg0, arg1, arg2, arg3)
			arg0.rt = arg1
			arg0.pos = arg2

			setAnchoredPosition(arg0.rt, arg0.pos)

			arg0.controller = arg3
			arg0.isTriggered = false
			arg0.comSpineAnim = arg1:Find("GameObject"):GetComponent("SpineAnimUI")

			arg0.comSpineAnim:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					arg0:ActionCallback()
				end
			end)
			arg0:Show("base")
		end

		function var0.ActionCallback(arg0)
			switch(arg0.state, {
				base = function()
					return
				end,
				trigger = function()
					arg0:Clear()
				end,
				broken = function()
					arg0:Clear()
				end
			})
		end

		function var0.Show(arg0, ...)
			var0.super.Show(arg0, ...)

			arg0.action = arg0.actionDic[arg0.state]

			arg0.comSpineAnim:SetAction(arg0.action, 0)
		end

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			if arg1.invincibleTime then
				arg0:Show("broken")
				pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-crash")
			else
				arg0:Show("trigger")
				arg0:TriggerEffect(arg1)
			end
		end

		return var0
	end,
	function()
		local var0 = class("TrafficCone", var0.Obstacle)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0.actionDic = {
			trigger = "roadblocks_vanish1",
			broken = "roadblocks_smash1",
			base = "roadblocks_normal1"
		}

		return var0
	end,
	function()
		local var0 = class("Roadblock", var0.Obstacle)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0.actionDic = {
			trigger = "roadblocks_vanish2",
			broken = "roadblocks_smash2",
			base = "roadblocks_normal2"
		}

		return var0
	end,
	function()
		local var0 = class("Bomb", var0.Obstacle)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}
		var0.actionDic = {
			trigger = "bomb",
			broken = "bombsmash",
			base = "bomb_normal"
		}

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			if arg1.invincibleTime then
				arg0:Show("broken")
			else
				arg0:Show("trigger")

				arg0.rt:Find("GameObject"):GetComponent("SkeletonGraphic").color = Color.New(1, 1, 1, 0)

				setActive(arg0.rt:Find("GameObject/saiche_zhadan"), true)
				arg0:TriggerEffect(arg1)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/baozha1")
		end

		return var0
	end,
	function()
		local var0 = class("Item", var0.Object)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0.Trigger(arg0, arg1)
			arg0.isTriggered = true

			arg0:TriggerEffect(arg1)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:/ui/mini_perfect")
			arg0:Clear()
		end

		return var0
	end,
	function()
		return (class("MoreTime", var0.Item))
	end,
	function()
		return (class("Invincibility", var0.Item))
	end,
	function()
		local var0 = class("Motorcycle", var0.Object)

		var0.colliderSize = {
			{
				-100,
				100
			},
			{
				-114,
				114
			}
		}

		function var0.Ctor(arg0, arg1, arg2, arg3)
			arg0.rt = arg1
			arg0.pos = arg2

			setAnchoredPosition(arg0.rt, arg0.pos)

			arg0.controller = arg3
			arg0.isTriggered = false
			arg0.comSpineAnim = arg1:Find("GameObject"):GetComponent(typeof(SpineAnimUI))

			arg0.comSpineAnim:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					arg0:ActionCallback()
				end
			end)

			arg0.effectList = {}

			for iter0, iter1 in ipairs({
				"saiche_sudu_01",
				"saiche_sudu_02",
				"saiche_sudu_03",
				"saiche_sudu_04"
			}) do
				table.insert(arg0.effectList, arg0.rt:Find("GameObject/" .. iter1))
			end

			arg0:Show("base")
		end

		function var0.UpdatePos(arg0, arg1, arg2)
			arg0.pos = arg0.pos + arg1
			arg0.pos.y = math.clamp(arg0.pos.y, -arg2, arg2)

			setAnchoredPosition(arg0.rt, arg0.pos)
		end

		function var0.ActionCallback(arg0)
			switch(arg0.action, {
				ride = function()
					return
				end,
				accel = function()
					arg0.action = "ride"

					arg0.comSpineAnim:SetAction(arg0.action, 0)
				end,
				fall = function()
					arg0.isBlock = false

					arg0:Show("base")
				end,
				yunxuan = function()
					arg0.isVertigo = false

					setActive(arg0.rt:Find("GameObject/saiche_xuanyun"), false)
					setActive(arg0.rt:Find("GameObject/saiche_jiansu"), false)
					arg0:Show("accel")
				end
			})
		end

		function var0.Show(arg0, ...)
			var0.super.Show(arg0, ...)
			switch(arg0.state, {
				base = function()
					arg0.action = "stop"
				end,
				accel = function()
					if not arg0.afterFirstAccel then
						arg0.afterFirstAccel = true
						arg0.action = "accel"
					else
						arg0.action = "ride"
					end
				end,
				fall = function()
					arg0.action = "fall"
					arg0.isBlock = true
				end,
				yunxuan = function()
					arg0.action = "yunxuan"
					arg0.isVertigo = true

					setActive(arg0.rt:Find("GameObject/saiche_xuanyun"), true)
					setActive(arg0.rt:Find("GameObject/saiche_jiansu"), true)
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-yunxuan")
				end
			})
			arg0.comSpineAnim:SetAction(arg0.action, 0)
		end

		function var0.TriggerEffect(arg0, arg1)
			switch(arg1.__cname, {
				MoreTime = function()
					arg0.controller:AddTime(RacingMiniGameConfig.ITEM_ADD_TIME)
				end,
				Invincibility = function()
					arg0.invincibleTime = RacingMiniGameConfig.INVINCIBLE_TIME

					setActive(arg0.rt:Find("invincibility"), true)
				end,
				TrafficCone = function()
					arg0.controller:SetEnginePower(0)
					arg0:Show("fall")
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-fall")
				end,
				Roadblock = function()
					arg0.controller:SetEnginePower(0)
					arg0:Show("fall")
					pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-fall")
				end,
				Bomb = function()
					arg0.controller:SetEnginePower(0)
					arg0:Show("fall")
				end,
				Mire = function()
					arg0.controller:SetEnginePower(math.min(arg0.controller.enginePower, RacingMiniGameConfig.OBSTACLE_POWER_BLOCK))
					arg0:Show("yunxuan")
				end,
				SpeedBumps = function()
					arg0.controller:SetEnginePower(math.min(arg0.controller.enginePower, RacingMiniGameConfig.OBSTACLE_POWER_BLOCK))
					arg0:Show("yunxuan")
				end
			})
		end

		function var0.UpdateInvincibility(arg0, arg1)
			assert(arg0.invincibleTime)

			arg0.invincibleTime = arg0.invincibleTime - arg1

			if arg0.invincibleTime <= 0 then
				setActive(arg0.rt:Find("invincibility"), false)

				arg0.invincibleTime = nil
			else
				local var0 = arg0.invincibleTime < 2

				setActive(arg0.rt:Find("invincibility/saiche_wudihudun_xiaoshi"), var0)
				setActive(arg0.rt:Find("invincibility/saiche_wudihudun"), not var0)
			end
		end

		return var0
	end
}

for iter0, iter1 in ipairs(var1) do
	local var2 = iter1()

	var0[var2.__cname] = var2
end

return var0
