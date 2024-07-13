local var0_0 = class("RectKeyTriggerController")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._keyInfo = arg1_1

	if not arg0_1.handle then
		arg0_1.handle = UpdateBeat:CreateListener(arg0_1.Update, arg0_1)
	end

	UpdateBeat:AddListener(arg0_1.handle)
end

function var0_0.Update(arg0_2)
	if Application.isEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_2._keyInfo:setKeyPress(KeyCode.A, true)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_2._keyInfo:setKeyPress(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_2._keyInfo:setKeyPress(KeyCode.A, false)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_2._keyInfo:setKeyPress(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.Space) then
			arg0_2._keyInfo:setKeyPress(KeyCode.Space, true)
		end

		if Input.GetKeyUp(KeyCode.Space) then
			arg0_2._keyInfo:setKeyPress(KeyCode.Space, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_2._keyInfo:setKeyPress(KeyCode.J, true)
		end

		if Input.GetKeyUp(KeyCode.J) then
			arg0_2._keyInfo:setKeyPress(KeyCode.J, false)
		end
	end
end

function var0_0.destroy(arg0_3)
	if arg0_3.handle then
		UpdateBeat:RemoveListener(arg0_3.handle)

		arg0_3.handle = nil
	end
end

return var0_0
