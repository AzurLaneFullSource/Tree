local var0_0 = class("VoteAwardPtWindow", import("view.activity.Panels.PtAwardWindow"))

var0_0.TYPE_CURR = 1
var0_0.TYPE_ACC = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1.binder = arg2_1
	arg0_1.scrollPanel = arg0_1._tf:Find("frame/panel")
	arg0_1.UIlist = UIItemList.New(arg0_1._tf:Find("frame/panel/list"), arg0_1._tf:Find("frame/panel/list/tpl"))
	arg0_1.ptTF = arg0_1._tf:Find("frame/pt")
	arg0_1.totalTxt = arg0_1._tf:Find("frame/pt/Text"):GetComponent(typeof(Text))
	arg0_1.totalTitleTxt = arg0_1._tf:Find("frame/pt/title"):GetComponent(typeof(Text))
end

function var0_0.UpdateTitle(arg0_2, arg1_2)
	if arg1_2 == var0_0.TYPE_CURR then
		arg0_2.resTitle, arg0_2.cntTitle = i18n("vote_lable_curr_title_1"), i18n("vote_lable_curr_title_2")
	elseif arg1_2 == var0_0.TYPE_ACC then
		arg0_2.resTitle, arg0_2.cntTitle = i18n("vote_lable_acc_title_1"), i18n("vote_lable_acc_title_2")
	end
end

function var0_0.updateResIcon(arg0_3)
	return
end

return var0_0
