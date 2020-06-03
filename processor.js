// processor.js
module.exports = async function(job){
    wait_time = parseInt(job.data.complexity) * 1000;
    await Sleep(wait_time);
    return true
}

function Sleep(milliseconds) {
    return new Promise(resolve => setTimeout(resolve, milliseconds));
 }