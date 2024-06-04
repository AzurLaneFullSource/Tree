local var0 = class("RectKeyTriggerController")

function var0.Ctor(arg0, arg1)
	arg0._keyInfo = arg1

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Update(arg0)
	if Application.isEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0._keyInfo:setKeyPress(KeyCode.A, true)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0._keyInfo:setKeyPress(KeyCode.D, true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0._keyInfo:setKeyPress(KeyCode.A, false)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0._keyInfo:setKeyPress(KeyCode.D, false)
		end

		if Input.GetKeyDown(KeyCode.Space) then
			arg0._keyInfo:setKeyPress(KeyCode.Space, true)
		end

		if Input.GetKeyUp(KeyCode.Space) then
			arg0._keyInfo:setKeyPress(KeyCode.Space, false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0._keyInfo:setKeyPress(KeyCode.J, true)
		end

		if Input.GetKeyUp(KeyCode.J) then
			arg0._keyInfo:setKeyPress(KeyCode.J, false)
		end
	end
end

function var0.destroy(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)

		arg0.handle = nil
	end
end

return var0
