local var0_0 = class("CookGameJudgesController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._sceneTf = findTF(arg1_1, "scene")
	arg0_1._sceneBackground = findTF(arg1_1, "scene_background")
	arg0_1._sceneFrontTf = findTF(arg1_1, "scene_front")
	arg0_1._tpl = findTF(arg0_1._sceneBackground, "judgeTpl")
	arg0_1._gameData = arg2_1
	arg0_1._event = arg3_1
	arg0_1.initFlag = false
	arg0_1.jiujiuTf = findTF(arg0_1._sceneBackground, "jiujiuTime")
	arg0_1.jiujiuAnim = GetComponent(findTF(arg0_1.jiujiuTf, "anim"), typeof(Animator))

	setActive(arg0_1._tpl, false)
end

function var0_0.init(arg0_2)
	arg0_2.initFlag = true
	arg0_2._judgeDatas = {}

	for iter0_2 = 1, #CookGameConst.judge_data do
		local var0_2 = CookGameConst.judge_data[iter0_2]
		local var1_2 = ResourceMgr.Inst:getAssetSync(arg0_2._gameData.path, var0_2.name, typeof(RuntimeAnimatorController), false, false)

		table.insert(arg0_2._judgeDatas, {
			data = Clone(var0_2),
			runtimeAnimator = var1_2
		})
	end

	arg0_2.judges = {}

	for iter1_2 = 1, CookGameConst.judge_num do
		local var2_2 = iter1_2
		local var3_2 = tf(instantiate(arg0_2._tpl))
		local var4_2 = findTF(arg0_2._sceneBackground, "judgesPos" .. iter1_2).anchoredPosition

		setParent(var3_2, arg0_2._sceneTf)
		setActive(var3_2, true)

		var3_2.anchoredPosition = var4_2

		local var5_2 = CookGameJudge.New(var3_2, var2_2, arg0_2._judgeDatas, arg0_2._gameData, arg0_2._event)

		var5_2:setFrontContainer(arg0_2._sceneFrontTf)
		var5_2:setClickCallback(function()
			arg0_2:onJudgeClick(var2_2)
		end)
		table.insert(arg0_2.judges, var5_2)
	end

	arg0_2._gameData.judges = arg0_2.judges
end

function var0_0.changeSpeed(arg0_4, arg1_4)
	for iter0_4 = 1, #arg0_4.judges do
		arg0_4.judges[iter0_4]:changeSpeed(arg1_4)
	end
end

function var0_0.serverIndex(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg1_5 and arg1_5 < #arg0_5.judges then
		arg0_5.judges[arg1_5]:server(arg2_5, arg3_5)
	else
		arg3_5(false)
	end
end

function var0_0.onJudgeClick(arg0_6, arg1_6)
	for iter0_6 = 1, #arg0_6.judges do
		if iter0_6 == arg1_6 then
			arg0_6.judges[iter0_6]:select(true)
			arg0_6._event:emit(CookGameView.CLICK_JUDGE_EVENT, arg0_6.judges[arg1_6], function(arg0_7)
				if not arg0_7 then
					arg0_6.judges[iter0_6]:select(false)
				end
			end)
		else
			arg0_6.judges[iter0_6]:select(false)
		end
	end
end

function var0_0.start(arg0_8)
	if not arg0_8.initFlag then
		arg0_8:init()
	end

	for iter0_8 = 1, #arg0_8.judges do
		arg0_8.judges[iter0_8]:start()
	end
end

function var0_0.step(arg0_9, arg1_9)
	for iter0_9 = 1, #arg0_9.judges do
		arg0_9.judges[iter0_9]:step(arg1_9)
	end
end

function var0_0.clear(arg0_10)
	for iter0_10 = 1, #arg0_10.judges do
		arg0_10.judges[iter0_10]:clear()
	end
end

function var0_0.extend(arg0_11)
	if arg0_11.jiujiuAnim then
		arg0_11.jiujiuAnim:SetTrigger("extend")
	end
end

function var0_0.timeUp(arg0_12)
	if arg0_12.jiujiuAnim then
		arg0_12.jiujiuAnim:SetTrigger("time_up")
	end
end

return var0_0
