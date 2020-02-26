javascript: (function(){
    let ans = "";

    let i=0;
    while($(`.lang-ja #pre-sample${i}`).length > 0) {
        const input = $(`#pre-sample${i}`).html().trim();
        const expect = $(`#pre-sample${i+1}`).html().trim();
        ans += input + "\n---\n" + expect + "\n===\n";
        i += 2;
    }
    console.log(ans);
    navigator.clipboard.writeText(ans);
})();
