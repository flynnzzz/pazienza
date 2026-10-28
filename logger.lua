local Logger = { buffer = {}, bufsize = 1 }

function Logger.log(msg, condition)
	if condition == nil then
		condition = true
	end
	if condition then
		print(msg)
	end
end

function Logger:cache(str, condition)
	if condition == nil then
		condition = true
	end
	if condition then
		self.buffer[self.bufsize] = str
		self.bufsize = self.bufsize + 1
	end
end

function Logger:flush(condition)
	if condition == nil then
		condition = true
	end
	if condition then
		io.write(table.concat(self.buffer))
		self.buffer = {}
		self.bufsize = 1
	end
end

return Logger
