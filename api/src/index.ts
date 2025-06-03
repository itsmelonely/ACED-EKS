import express, { json } from 'express'
import multer from 'multer'
import { exec, execSync } from 'child_process'
import { chdir, cwd } from 'process'
import path from 'path'
import { appendFileSync, existsSync, readdirSync, readFileSync, writeFileSync } from 'fs'
import cors from 'cors'


const app = express()
const upload = multer({ dest: 'uploads/' })
const workingDir = cwd()
const processingTask: {
    isAvaliable: boolean
    projectID: string | null
} = {
    isAvaliable: true,
    projectID: null
}

const titleCase = (s:string) =>
    s.replace(/^_*(.)|_+(.)/g, (s, c, d) => c ? c.toUpperCase() : ' ' + d.toUpperCase())

async function main () {
    app.use(cors())
    app.use(json())

    app.get('/api/v1/templates', (req, res, next) => {
        const templates = readdirSync(path.join(cwd(), 'templates'))
        res.json({
            templates: templates.map(t => ({
                name: titleCase(t.replace('.zip', '')),
                file: path.join('templates', t)
        }))})
    })

    app.post('/api/v1/projects', (req, res, next) => {
        try {
            if(!existsSync(`projects/${req.body.profile.projectName}`))
            execSync(`unzip -o ${req.body.template.file} -d projects/${req.body.profile.projectName}`)
            console.log(req.body)
            res.json({status: 200, request:req.body})
        } catch (error) {
            console.error(error)
            res.status(500).json(error)
        }
    })

    app.get('/api/v1/project/:projectName/var', (req, res, next) => {
        try {
            const file = readFileSync(path.join(cwd(), 'projects',req.params.projectName, 'variables.tf'), 'utf8')
            res.json({status: 200, file})
        } catch (error) {
            console.error(error)
            res.status(500).json(error)
        }
    })

    app.get('/api/v1/project/:projectName/setting', (req, res, next) => {
        try {
            const file = readFileSync(path.join(cwd(), 'projects',req.params.projectName, 'var.tfvars'), 'utf8')
            res.json({status: 200, file})
        } catch (error) {
            console.error(error)
            res.status(500).json(error)
        }
    })

    app.post('/api/v1/project/:projectName/setting', (req, res, next) => {
        try {
            console.log(req.body.file)
            writeFileSync(path.join(cwd(), 'projects',req.params.projectName, 'var.tfvars'), req.body.file)
            res.json({status: 200, file:req.body.file})
        } catch (error) {
            console.error(error)
            res.status(500).json(error)
        }
    })

    app.post('/api/v1/project/:projectName/launch', (req, res, next) => {
        res.json({ status: 200, state: 'running', projectName: req.params.projectName })
        try {
            const commands = [
                'terraform init',
                'terraform apply -auto-approve -var-file="var.tfvars"'
            ]
            for (const cmd of commands) {
                const workingPath = path.resolve(path.join(cwd(), 'projects', req.params.projectName))
                console.log('Exec', cmd, workingPath)
                execSync(cmd, {
                    env: {
                        ...process.env,
                        AWS_ACCESS_KEY_ID: req.body.accessKey,
                        AWS_SECRET_ACCESS_KEY: req.body.secretKey,
                        AWS_REGION: req.body.region,
                    },
                    cwd: workingPath,
                })
            }
            console.log('Complete')
        } catch (error:any) {
            console.error(error)
        }
    })
    
    app.listen(3000, () => {
        console.log('Application on localhost:3000')
    })
}

main()