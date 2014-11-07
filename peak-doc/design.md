# Peak Design

- Files
- Processes
- System Calls

- syscall `wait(promise...): data...`
- syscall `sleep(time): promise`

### Files
- syscall `list(path): promise[names]` - NOPE!, see directory:next
- syscall `rename(path, name): promise`
- syscall `move(path, dir): promise`
- syscall `movename(path, dir, name): promise`
- syscall `delete(path): promise`
- syscall `open(path): promise[handle]`
- syscall `close(handle): promise`

### Basic Files
- just store data
- syscall `seek(handle, offset): promise[offset]`
- syscall `getOffset(handle): promise[offset]`
- syscall `read(handle, length): promise[data]`
- syscall `write(handle, data): promise[written]`

### Stream Files
- queue
- syscall `read(handle): promise[msg)`
- syscall `write(handle, msg): promise`

### API Files
- store an API
- syscall `list(handle): promise[methods]`
- syscall `call(handle, name, args...): promise[result...]`
- syscall `read(handle): promise[id, name, args...]`
- syscall `respond(handle, id, res...): promise`

### Directory
- syscall `next(): promise[string]`