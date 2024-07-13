local var0_0 = class("IdolTrainUI", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IdolTrainUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
	setActive(arg0_2._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.onTrain = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_3._tf, arg0_3._parentTF)
end

function var0_0.InitUI(arg0_4)
	arg0_4.trainBtn = arg0_4:findTF("panel/train_btn")
	arg0_4.skills = arg0_4:findTF("panel/skills")
	arg0_4.info = arg0_4:findTF("panel/info")
	arg0_4.skillBtns = {}

	eachChild(arg0_4.skills, function(arg0_5)
		table.insert(arg0_4.skillBtns, arg0_5)
	end)

	arg0_4.curBuff = arg0_4:findTF("preview/current", arg0_4.info)
	arg0_4.nextBuff = arg0_4:findTF("preview/next", arg0_4.info)
	arg0_4.currentBuffLv = arg0_4:findTF("title/lv/current", arg0_4.info)
	arg0_4.nextBuffLv = arg0_4:findTF("title/lv/next", arg0_4.info)
end

function var0_0.setCBFunc(arg0_6, arg1_6)
	arg0_6.onTrain = arg1_6
end

function var0_0.set(arg0_7, arg1_7, arg2_7)
	arg0_7.buffInfos = arg1_7
	arg0_7.targetIndex = arg2_7
	arg0_7.selectIndex = nil
	arg0_7.selectBuffId = nil
	arg0_7.selectBuffLv = nil
	arg0_7.selectNewBuffId = nil

	for iter0_7, iter1_7 in ipairs(arg0_7.skillBtns) do
		onButton(arg0_7, iter1_7, function()
			for iter0_8, iter1_8 in ipairs(arg0_7.buffInfos) do
				if iter0_7 == iter1_8.group then
					if iter1_8.next then
						arg0_7.selectIndex = iter0_7
						arg0_7.selectBuffId = iter1_8.id
						arg0_7.selectNewBuffId = iter1_8.next
						arg0_7.selectBuffLv = iter1_8.lv
					else
						arg0_7.selectIndex = nil
						arg0_7.selectBuffId = nil
						arg0_7.selectNewBuffId = nil
						arg0_7.selectBuffLv = nil
					end
				end
			end

			arg0_7:flush()
		end, SFX_PANEL)
	end

	onButton(arg0_7, arg0_7.trainBtn, function()
		if arg0_7.onTrain and arg0_7.selectBuffId then
			local var0_9 = pg.benefit_buff_template[arg0_7.selectBuffId].name

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = "是否要对" .. var0_9 .. "进行训练" .. arg0_7.selectBuffId,
				onYes = function()
					arg0_7.onTrain(arg0_7.targetIndex, arg0_7.selectNewBuffId, arg0_7.selectBuffId)
					arg0_7:Destroy()
				end
			})
		end
	end, SFX_PANEL)
	arg0_7:flush()
end

function var0_0.flush(arg0_11)
	if arg0_11.buffInfos then
		for iter0_11, iter1_11 in ipairs(arg0_11.buffInfos) do
			if iter1_11.next then
				setText(arg0_11:findTF("lv", arg0_11.skillBtns[iter1_11.group]), "Lv." .. iter1_11.lv)
			else
				setText(arg0_11:findTF("lv", arg0_11.skillBtns[iter1_11.group]), "MAX")
			end
		end
	end

	for iter2_11, iter3_11 in ipairs(arg0_11.skillBtns) do
		if iter2_11 == arg0_11.selectIndex then
			setActive(arg0_11:findTF("selected", iter3_11), true)
		else
			setActive(arg0_11:findTF("selected", iter3_11), false)
		end
	end

	if arg0_11.selectIndex then
		setActive(arg0_11.info, true)
		setActive(arg0_11.trainBtn, true)
		setText(arg0_11.curBuff, pg.benefit_buff_template[arg0_11.selectBuffId].desc)
		setText(arg0_11.nextBuff, pg.benefit_buff_template[arg0_11.selectNewBuffId].desc)
		setText(arg0_11.nextBuffLv, "Lv." .. arg0_11.selectBuffLv + 1)
		setText(arg0_11.currentBuffLv, "Lv." .. arg0_11.selectBuffLv)
	else
		setActive(arg0_11.info, false)
		setActive(arg0_11.trainBtn, false)
	end
end

return var0_0
