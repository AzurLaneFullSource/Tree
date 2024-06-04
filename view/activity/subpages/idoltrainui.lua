local var0 = class("IdolTrainUI", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "IdolTrainUI"
end

function var0.OnInit(arg0)
	arg0:InitUI()
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.OnDestroy(arg0)
	arg0.onTrain = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTF)
end

function var0.InitUI(arg0)
	arg0.trainBtn = arg0:findTF("panel/train_btn")
	arg0.skills = arg0:findTF("panel/skills")
	arg0.info = arg0:findTF("panel/info")
	arg0.skillBtns = {}

	eachChild(arg0.skills, function(arg0)
		table.insert(arg0.skillBtns, arg0)
	end)

	arg0.curBuff = arg0:findTF("preview/current", arg0.info)
	arg0.nextBuff = arg0:findTF("preview/next", arg0.info)
	arg0.currentBuffLv = arg0:findTF("title/lv/current", arg0.info)
	arg0.nextBuffLv = arg0:findTF("title/lv/next", arg0.info)
end

function var0.setCBFunc(arg0, arg1)
	arg0.onTrain = arg1
end

function var0.set(arg0, arg1, arg2)
	arg0.buffInfos = arg1
	arg0.targetIndex = arg2
	arg0.selectIndex = nil
	arg0.selectBuffId = nil
	arg0.selectBuffLv = nil
	arg0.selectNewBuffId = nil

	for iter0, iter1 in ipairs(arg0.skillBtns) do
		onButton(arg0, iter1, function()
			for iter0, iter1 in ipairs(arg0.buffInfos) do
				if iter0 == iter1.group then
					if iter1.next then
						arg0.selectIndex = iter0
						arg0.selectBuffId = iter1.id
						arg0.selectNewBuffId = iter1.next
						arg0.selectBuffLv = iter1.lv
					else
						arg0.selectIndex = nil
						arg0.selectBuffId = nil
						arg0.selectNewBuffId = nil
						arg0.selectBuffLv = nil
					end
				end
			end

			arg0:flush()
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.trainBtn, function()
		if arg0.onTrain and arg0.selectBuffId then
			local var0 = pg.benefit_buff_template[arg0.selectBuffId].name

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = "是否要对" .. var0 .. "进行训练" .. arg0.selectBuffId,
				onYes = function()
					arg0.onTrain(arg0.targetIndex, arg0.selectNewBuffId, arg0.selectBuffId)
					arg0:Destroy()
				end
			})
		end
	end, SFX_PANEL)
	arg0:flush()
end

function var0.flush(arg0)
	if arg0.buffInfos then
		for iter0, iter1 in ipairs(arg0.buffInfos) do
			if iter1.next then
				setText(arg0:findTF("lv", arg0.skillBtns[iter1.group]), "Lv." .. iter1.lv)
			else
				setText(arg0:findTF("lv", arg0.skillBtns[iter1.group]), "MAX")
			end
		end
	end

	for iter2, iter3 in ipairs(arg0.skillBtns) do
		if iter2 == arg0.selectIndex then
			setActive(arg0:findTF("selected", iter3), true)
		else
			setActive(arg0:findTF("selected", iter3), false)
		end
	end

	if arg0.selectIndex then
		setActive(arg0.info, true)
		setActive(arg0.trainBtn, true)
		setText(arg0.curBuff, pg.benefit_buff_template[arg0.selectBuffId].desc)
		setText(arg0.nextBuff, pg.benefit_buff_template[arg0.selectNewBuffId].desc)
		setText(arg0.nextBuffLv, "Lv." .. arg0.selectBuffLv + 1)
		setText(arg0.currentBuffLv, "Lv." .. arg0.selectBuffLv)
	else
		setActive(arg0.info, false)
		setActive(arg0.trainBtn, false)
	end
end

return var0
