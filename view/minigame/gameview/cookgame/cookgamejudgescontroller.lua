local var0 = class("CookGameJudgesController")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._sceneTf = findTF(arg1, "scene")
	arg0._sceneBackground = findTF(arg1, "scene_background")
	arg0._sceneFrontTf = findTF(arg1, "scene_front")
	arg0._tpl = findTF(arg0._sceneBackground, "judgeTpl")
	arg0._gameData = arg2
	arg0._event = arg3
	arg0.initFlag = false
	arg0.jiujiuTf = findTF(arg0._sceneBackground, "jiujiuTime")
	arg0.jiujiuAnim = GetComponent(findTF(arg0.jiujiuTf, "anim"), typeof(Animator))

	setActive(arg0._tpl, false)
end

function var0.init(arg0)
	arg0.initFlag = true
	arg0._judgeDatas = {}

	for iter0 = 1, #CookGameConst.judge_data do
		local var0 = CookGameConst.judge_data[iter0]
		local var1 = ResourceMgr.Inst:getAssetSync(arg0._gameData.path, var0.name, typeof(RuntimeAnimatorController), false, false)

		table.insert(arg0._judgeDatas, {
			data = Clone(var0),
			runtimeAnimator = var1
		})
	end

	arg0.judges = {}

	for iter1 = 1, CookGameConst.judge_num do
		local var2 = iter1
		local var3 = tf(instantiate(arg0._tpl))
		local var4 = findTF(arg0._sceneBackground, "judgesPos" .. iter1).anchoredPosition

		setParent(var3, arg0._sceneTf)
		setActive(var3, true)

		var3.anchoredPosition = var4

		local var5 = CookGameJudge.New(var3, var2, arg0._judgeDatas, arg0._gameData, arg0._event)

		var5:setFrontContainer(arg0._sceneFrontTf)
		var5:setClickCallback(function()
			arg0:onJudgeClick(var2)
		end)
		table.insert(arg0.judges, var5)
	end

	arg0._gameData.judges = arg0.judges
end

function var0.changeSpeed(arg0, arg1)
	for iter0 = 1, #arg0.judges do
		arg0.judges[iter0]:changeSpeed(arg1)
	end
end

function var0.serverIndex(arg0, arg1, arg2, arg3)
	if arg1 and arg1 < #arg0.judges then
		arg0.judges[arg1]:server(arg2, arg3)
	else
		arg3(false)
	end
end

function var0.onJudgeClick(arg0, arg1)
	for iter0 = 1, #arg0.judges do
		if iter0 == arg1 then
			arg0.judges[iter0]:select(true)
			arg0._event:emit(CookGameView.CLICK_JUDGE_EVENT, arg0.judges[arg1], function(arg0)
				if not arg0 then
					arg0.judges[iter0]:select(false)
				end
			end)
		else
			arg0.judges[iter0]:select(false)
		end
	end
end

function var0.start(arg0)
	if not arg0.initFlag then
		arg0:init()
	end

	for iter0 = 1, #arg0.judges do
		arg0.judges[iter0]:start()
	end
end

function var0.step(arg0, arg1)
	for iter0 = 1, #arg0.judges do
		arg0.judges[iter0]:step(arg1)
	end
end

function var0.clear(arg0)
	for iter0 = 1, #arg0.judges do
		arg0.judges[iter0]:clear()
	end
end

function var0.extend(arg0)
	if arg0.jiujiuAnim then
		arg0.jiujiuAnim:SetTrigger("extend")
	end
end

function var0.timeUp(arg0)
	if arg0.jiujiuAnim then
		arg0.jiujiuAnim:SetTrigger("time_up")
	end
end

return var0
