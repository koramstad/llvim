local f = io.open("/tmp/job-out.txt", "w")

local job = vim.fn.jobstart({"script", "-q", "-c", "/home/koramstad/.opencode/bin/opencode run 'hello'", "/dev/null"}, {
  stdout_buffered = false,
  pty = true,
  on_stdout = function(job_id, data)
    if f then f:write("stdout: " .. vim.inspect(data) .. "\n") f:flush() end
  end,
  on_stderr = function(job_id, data)
    if f then f:write("stderr: " .. vim.inspect(data) .. "\n") f:flush() end
  end,
  on_exit = function(job_id, code)
    if f then f:write("exit: " .. code .. "\n") f:flush() f:close() end
  end,
})

if f then f:write("job: " .. job .. "\n") f:flush() end

vim.defer_fn(function()
  if f then f:write("defer_fn fired\n") f:close() end
end, 10000)