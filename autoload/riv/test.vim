"=============================================
"    Name: test.vim
"    File: test.vim
" Summary: 
"  Author: Rykka G.Forest
"  Update: 2012-06-11
" Version: 0.5
"=============================================
let s:cpo_save = &cpo
set cpo-=C



function! s:time() "{{{
    if has("reltime")
        return str2float(reltimestr(reltime()))
    else
        return localtime()
    endif
endfunction "}}}
function! riv#test#timer(func,...) "{{{
    if !exists("*".a:func)
        call s:debug("[TIMER]: ".a:func." does not exists. stopped")
        return
    endif
    let num  = a:0 ? a:1 : 1
    let farg = a:0>1 ? a:2 : []

    let o_t = s:time()

    for i in range(num)
        sil! let rtn = call(a:func,farg)
    endfor
    let e_t = s:time()
    let time = printf("%.4f",(e_t-o_t))
    echom "[TIMER]: " . time . " seconds for exec" a:func num "times. "

    return rtn
endfunction "}}}
fun! riv#test#log(msg) "{{{
    
    let log =  "Time:". strftime("%Y-%m-%d %H:%M")
    " write time to log.
    let file = expand("~/Desktop/test.log")
    if filereadable(file)
        let lines = readfile(file)
    else
        let lines = []
    endif
    call add(lines, log)
    if type(a:msg) == type([])
        call extend(lines, a:msg)
    else
        call add(lines, a:msg)
    endif
    call writefile(lines, file)
endfun "}}}
fun! riv#test#fold(...) "{{{
    let line=line('.')
    let o_t = s:time()
    if a:0>0 && a:1==0
        for i in range(1,line('$'))
            let fdl = riv#fold#expr(i)
        endfor
        echo "Total time: " (s:time()-o_t)
        let t = "1"
    else
        echo "row\texpr\tb:fdl\tb:bef_ex\tb:in_exp\tb:in_lst\tb:bef_lst"
        for i in range(1,line('$'))
            let fdl = riv#fold#expr(i)
            if i>= line-10 && i <= line+10
                echo i."\t".fdl
                if exists("b:foldlevel")
                    echon " \t     " b:foldlevel
                else
                    echon " \tN/A      " 
                endif
                if exists("b:fdl_before_exp")
                    echon " \t    " b:fdl_before_exp
                else
                    echon " \tN/A      " 
                endif
                if exists("b:is_in_exp")
                    echon " \t      " b:is_in_exp
                else
                    echon " \tN/A      " 
                endif
                if exists("b:is_in_lst")
                    echon "     \t    " b:is_in_lst
                else
                    echon "     \tN/A       " 
                endif
                if exists("b:fdl_before_listlst")
                    echon "    \t     " b:fdl_before_listlst
                else
                    echon " \tN/A      " 
                endif
                if line == i
                    echon " \t" ">> cur"
                endif
            endif
            if a:0>0 && a:1>1
                echo i ":" (s:time()-o_t)
            endif
        endfor
        echo "Total time: " (s:time()-o_t)
        let t = "2"
    endif

    let log =   [" File:" . expand('%:p') . "  TestFold :".t, 
               \ " Total time: " . string((s:time()-o_t)) 
               \]
    call riv#test#log(log)
endfun "}}}
fun! riv#test#buf() "{{{
    
    let o_t = s:time()
    call riv#fold#parse()
    echo "Total time: " (s:time()-o_t)
endfun "}}}
fun! riv#test#insert_idt() "{{{
    " breakadd func riv#insert#indent
    echo riv#insert#indent(line('.'))
endfun "}}}
fun! riv#test#reload()
    let g:riv_force=1 | set ft=rst | let g:riv_force=0
    sil! runtime! autoload/riv/*.vim
endfun

let &cpo = s:cpo_save
unlet s:cpo_save
